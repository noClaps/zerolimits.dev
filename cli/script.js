// @ts-check

/** @type {string[]} */
const cmdHistory = [];
let currentPos = cmdHistory.length - 1;

const input = document.querySelector("input");
if (!input) throw new Error("Input element not found");

const log = document.getElementById("log");
if (!log) throw new Error("Log element not found");

document.addEventListener(
  "click",
  (ev) => /** @type {HTMLElement} */ (ev.target).id !== "log" && input.focus(),
);

const output = {
  /** @param {any[]} data  */
  write: (...data) => (log.innerHTML += data.join("")),
  /** @param {any[]} data  */
  writeln: (...data) => (log.innerHTML += data.join("") + "\n"),
  /**
   * @param {string} flag
   * @param {string} usage
   */
  unknownFlagError(flag, usage) {
    const cmd = usage.split(" ", 2)[0];
    this.writeln(`${cmd}: unknown flag: `, flag);
    this.writeln("Usage: ", usage);
    this.writeln(`See ${cmd} --help for more information.`);
  },
  /**
   * @param {string[]} extraArgs
   * @param {string} usage
   */
  extraArgsError(extraArgs, usage) {
    const cmd = usage.split(" ", 2)[0];
    this.writeln(cmd, ": extra arguments provided: ", extraArgs);
    this.writeln("Usage: ", usage);
    this.writeln("See ", cmd, " --help for more information.");
  },
  /**
   * @param {string} arg
   * @param {string} usage
   */
  missingRequiredArgError(arg, usage) {
    const cmd = usage.split(" ", 2)[0];
    this.writeln(cmd, ": missing required argument: ", arg);
    this.writeln("Usage: ", usage);
    this.writeln("See ", cmd, " --help for more information.");
  },
  /**
   * @param {string} command
   * @param {string} message
   * @param {string | undefined} arg
   */
  commandError(command, message, arg = undefined) {
    this.write(command, ": ");
    if (arg) this.write(arg, ": ");
    this.writeln(message);
  },
  /**
   *
   * @param {string} command
   * @param {string} description
   * @param {Record<string, string>} positionals
   * @param {Record<string, string>} flags
   */
  printHelp(command, description, positionals = {}, flags = {}) {
    this.write("Usage: ", command);
    let pos = Object.keys(positionals).map((p) => p.replaceAll("<", "&lt;"));
    if (pos.length > 0) this.write(" ", pos.join(" "));
    let flag = Object.keys(flags).map((f) => `[${f}]`);
    if (flag.length > 0) this.write(" ", flag.join(" "));
    this.writeln();

    this.writeln(description);
    let maxLen = 10; // "-h, --help"
    for (const flag in flags) maxLen = Math.max(maxLen, flag.length);
    for (const pos in positionals) maxLen = Math.max(maxLen, pos.length);

    /** @param {number} itemLen  */
    function totalSpace(itemLen) {
      return 2 + itemLen + Math.max(2, maxLen - itemLen + 2);
    }
    /** @param {Record<string, string>} items */
    const itemHelp = (items) => {
      for (const item in items) {
        this.write("  ", item.replaceAll("<", "&lt;"));
        this.write(" ".repeat(Math.max(2, maxLen - item.length + 2)));
        const helpLines = [];
        let currentLine = "";
        for (const word of items[item].split(" ")) {
          if (
            currentLine.length + word.length + 1 >
            80 - totalSpace(item.length)
          ) {
            helpLines.push(currentLine);
            currentLine = "";
          }
          if (currentLine != "") currentLine += " ";
          currentLine += word;
        }
        helpLines.push(currentLine);
        for (let i = 0; i < helpLines.length; i++) {
          if (i > 0) this.write(" ".repeat(totalSpace(item.length)));
          this.write(helpLines[i]);
          if (i + 1 < helpLines.length) this.writeln();
        }
      }
    };
    if (Object.keys(positionals).length > 0) this.writeln("Arguments:");
    itemHelp(positionals);
    this.writeln("Options:");
    itemHelp(flags);
    this.writeln(
      "  -h, --help",
      " ".repeat(Math.max(2, maxLen - 8)),
      "Show this help and exit.",
    );
  },
};

/** @type {Record<string, (args: string[], flags: string[], help: boolean) => void>} */
const commands = {
  clear(args, flags, help) {
    if (help) return output.printHelp("clear", "Clear the screen");

    if (args.length > 0) return output.extraArgsError(args, "clear");
    if (flags.length > 0) return output.unknownFlagError(flags[0], "clear");

    log.innerHTML = "";
  },

  ls(args, flags, help) {
    if (help) {
      return output.printHelp(
        "ls",
        "List contents of directory",
        {
          "[directory]":
            "The directory for which to list contents. If this argument is not provided, the contents of all directories are listed. Directory names end with a backslash (/).",
        },
        {
          "--keys":
            "Display the keys of the listed links, so that they can be used with the `open` command. The keys are displayed in (parentheses) at the end of the links.",
        },
      );
    }

    let showKeys = flags.includes("--keys");
    let bad = flags.find((f) => f != "--keys");
    if (bad) return output.unknownFlagError(bad, "ls [directory] [--keys]");
    let [arg, ...extra] = args;
    if (extra.length)
      return output.extraArgsError(extra, "ls [directory] --keys");

    let wrote = false;
    let dir = arg?.replace(/^\/*|\/*$/g, "");
    /**
     * @param {string} name
     * @param {Record<string, any>} items
     * @param {((item: any, items: Record<string, any>, index: number) => string) | undefined} format
     * @param {((item: any, items: Record<string, any>, index: number) => string) | undefined} postFormat
     */
    function tree(name, items, format = undefined, postFormat = undefined) {
      if (dir && dir !== name) return;
      wrote = true;
      output.writeln(name, "/");
      Object.entries(items).forEach(([key, item], i) => {
        console.log(item);
        if (i > 0) output.writeln();
        if (i === Object.keys(items).length - 1) output.write("└");
        else output.write("├");
        output.write(`── ${item.name} - `);
        if (item.link)
          output.write(
            `<a href="${item.link}">${item["link-name"] ?? "Link"}</a>`,
          );
        if (format) output.write(format(item, items, i));
        if (showKeys) output.write(` (${key})`);
        if (postFormat) output.write("\n" + postFormat(item, items, i));
      });
      output.writeln();
    }
    // @ts-expect-error `directory` doesn't exist yet
    tree("contact", directory.contact);
    tree(
      "projects",
      // @ts-expect-error `directory` doesn't exist yet
      directory.projects,
      (p) => ` - <a href="${p.source}">Source</a>`,
      (p, projects, i) => {
        let out = "";
        if (i === Object.keys(projects).length - 1) out += " ";
        else out += "│";
        out += "   " + p.description;
        return out;
      },
    );

    if (!wrote) output.commandError("ls", "directory not found", arg);
  },

  open(args, flags, help) {
    if (help) {
      return output.printHelp(
        "open",
        "Open link or source in a new tab",
        {
          "<key>":
            "The key of the link you'd like to open. This will open the link to the website in a new tab. If the project doesn't have a website, the source link will be opened instead. You can obtain this key from the `ls --keys` command.",
        },
        {
          "--source":
            "Open the link to the source code, even if there is a website available. This flag cannot be used with a contact key.",
        },
      );
    }

    let openSource = flags.includes("--source");
    const bad = flags.find((f) => f != "--source");
    if (bad) return output.unknownFlagError(bad, "open <key> [source]");

    let [key, ...extra] = args;
    if (!key)
      return output.missingRequiredArgError("key", "open <key> [--source]");
    if (extra.length)
      return output.extraArgsError(extra, "open <key> [--source]");

    // @ts-expect-error `directory` doesn't exist yet
    let projects = directory.projects;
    if (key in projects) {
      if (openSource || !projects[key].link) {
        window.open(projects[key].source, "_blank");
        return;
      }

      window.open(projects[key].link, "_blank");
      return;
    }

    // @ts-expect-error `directory` doesn't exist yet
    const contact = directory.contact;
    if (key in contact) {
      if (openSource)
        return output.commandError(
          "open",
          "`--source` flag cannot be used with a contact key.",
        );

      window.open(contact[key].link, "_blank");
      return;
    }

    return output.commandError(
      "open",
      "unknown key. Use `ls --keys` to see available keys.",
      key,
    );
  },
};

input.addEventListener("keyup", (e) => {
  switch (e.key) {
    case "ArrowUp": {
      e.preventDefault();
      if (currentPos >= 0) input.value = cmdHistory[currentPos--];
      break;
    }

    case "ArrowDown": {
      e.preventDefault();
      input.value =
        currentPos < cmdHistory.length - 1 ? cmdHistory[++currentPos] : "";
      break;
    }

    case "Enter": {
      const cmd = input.value.toLowerCase().trim();
      cmdHistory.push(cmd);
      currentPos = cmdHistory.length - 1;

      const argv = cmd.split(/\s+/).filter(Boolean);
      let command = argv.shift();
      let help = argv.some((a) => a === "-h" || a === "--help");
      const flags = argv.filter(
        (a) => a.startsWith("-") && a !== "-h" && a !== "--help",
      );
      const args = argv.filter((a) => !a.startsWith("-"));

      output.writeln("user@zerolimits.dev / > ", input.value);

      if (command && commands[command]) commands[command](args, flags, help);
      else if (!command) output.write();
      else {
        // @ts-expect-error `directory` doesn't exist yet
        let entry = directory.projects[command];
        if (entry) {
          output.writeln(
            entry.name,
            " - ",
            entry.link ? `<a href="${entry.link}">Link</a> - ` : "",
            `<a href="${entry.source}">Source</a>`,
          );
          output.writeln(entry.description);
        }
        // @ts-expect-error `directory` doesn't exist yet
        else if ((entry = directory.contact[command]))
          output.writeln(
            `${entry.name} - <a href="${entry.link}">${entry["link-name"]}</a>`,
          );
        else output.commandError(command, "command not found");
      }

      scrollTo({ top: document.body.scrollHeight });
      input.value = "";
    }
  }
});
