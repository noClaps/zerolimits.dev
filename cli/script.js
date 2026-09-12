// @ts-check

/** @type {string[]} */
const cmdHistory = [];
let currentPos = cmdHistory.length - 1;

const input = document.querySelector("input");
if (!input) throw new Error("Input element not found");

const log = document.getElementById("log");
if (!log) throw new Error("Log element not found");

document.addEventListener("click", (ev) => {
  if (/** @type {HTMLElement} */ (ev.target).id === "log") return;
  input.focus();
});

const output = {
  /** @param {any[]} data  */
  write(...data) {
    log.innerHTML += data.join("");
  },
  /** @param {any[]} data  */
  writeln(...data) {
    log.innerHTML += data.join("");
    log.innerHTML += "\n";
  },
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
    if (Object.keys(positionals).length > 0) this.writeln("Arguments:");
    for (const pos in positionals) {
      this.write("  ", pos.replaceAll("<", "&lt;"));
      this.write(" ".repeat(Math.max(2, maxLen - pos.length + 2)));
      const helpLines = [];
      let currentLine = "";
      for (const word of positionals[pos].split(" ")) {
        if (
          currentLine.length + word.length + 1 >
          80 - totalSpace(pos.length)
        ) {
          helpLines.push(currentLine);
          currentLine = "";
        }
        if (currentLine != "") currentLine += " ";
        currentLine += word;
      }
      helpLines.push(currentLine);
      for (let i = 0; i < helpLines.length; i++) {
        if (i > 0) this.write(" ".repeat(totalSpace(pos.length)));
        this.write(helpLines[i]);
        if (i + 1 < helpLines.length) this.writeln();
      }
    }
    this.writeln("Options:");
    for (const flag in flags) {
      this.write("  ", flag);
      this.write(" ".repeat(maxLen - flag.length + 2));
      const helpLines = [];
      let currentLine = "";
      for (const word of flags[flag].split(" ")) {
        if (
          currentLine.length + word.length + 1 >
          80 - totalSpace(flag.length)
        ) {
          helpLines.push(currentLine);
          currentLine = "";
        }
        if (currentLine != "") currentLine += " ";
        currentLine += word;
      }
      helpLines.push(currentLine);
      for (let i = 0; i < helpLines.length; i++) {
        if (i > 0) this.write(" ".repeat(totalSpace(flag.length)));
        this.write(helpLines[i]);
        if (i + 1 < helpLines.length) this.writeln();
      }
    }
    this.writeln(
      "  -h, --help",
      " ".repeat(Math.max(2, maxLen - 8)),
      "Show this help and exit.",
    );
  },
};

/** @type {Record<"clear" | "ls" | "open", (args: string[], flags: string[], help: boolean) => void>} */
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
    let arg = args.shift();
    if (args.length > 0)
      return output.extraArgsError(args, "ls [directory] --keys");

    let wrote = false;
    let dir = arg?.replace(/^\/*|\/*$/g, "");
    if (!dir || dir === "contact") {
      wrote = true;
      output.writeln("contact/");
      // @ts-expect-error `directory` doesn't exist yet
      const contacts = directory.contact;
      Object.entries(contacts).forEach(([key, contact], i) => {
        if (i > 0) output.writeln();
        if (i === Object.keys(contacts).length - 1) output.write("└");
        else output.write("├");
        output.write(
          `── ${contact.name} - <a href="${contact.link}">${contact["link-name"]}</a>`,
        );
        if (showKeys) output.write(` (${key})`);
      });
      output.writeln();
    }
    if (!dir || dir === "projects") {
      wrote = true;
      output.writeln("projects/");
      // @ts-expect-error `directory` doesn't exist yet
      const projects = directory.projects;
      Object.entries(projects).forEach(([key, project], i) => {
        if (i > 0) output.writeln();
        if (i === Object.keys(projects).length - 1) output.write("└");
        else output.write("├");
        output.write(`── ${project.name} - `);
        if (project.link) output.write(`<a href="${project.link}">Link</a> - `);
        output.write(`<a href="${project.source}">Source</a>`);
        if (showKeys) output.write(` (${key})`);
        output.writeln();
        if (i === Object.keys(projects).length - 1) output.write(" ");
        else output.write("│");
        output.write("   ", project.description);
      });
      output.writeln();
    }

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

    let key = args.shift();
    if (!key)
      return output.missingRequiredArgError("key", "open <key> [--source]");
    if (args.length > 0)
      return output.extraArgsError(args, "open <key> [--source]");

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
      if (currentPos >= 0) {
        input.value = cmdHistory[currentPos];
        currentPos -= 1;
      }
      break;
    }

    case "ArrowDown": {
      e.preventDefault();
      if (currentPos < cmdHistory.length - 1) {
        currentPos += 1;
        input.value = cmdHistory[currentPos];
      } else {
        input.value = "";
      }

      break;
    }

    case "Enter": {
      const cmd = input.value.toLowerCase().trim();
      cmdHistory.push(cmd);
      currentPos = cmdHistory.length - 1;

      const argv = cmd.split(" ");
      const flags = [];
      const args = [];
      let help = false;
      let command = argv.shift();
      for (const a of argv) {
        if (a === "-h" || a === "--help") help = true;
        else if (a.startsWith("-")) flags.push(a);
        else args.push(a);
      }

      log.innerHTML += `user@zerolimits.dev / > ${input.value}\n`;

      if (command === "clear") commands.clear(args, flags, help);
      else if (command === "ls") commands.ls(args, flags, help);
      else if (command === "open") commands.open(args, flags, help);
      else {
        if (!command) {
          output.writeln();
          break;
        }
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
