// @ts-check

/** @type {string[]} */
const cmdHistory = [];
let currentPos = cmdHistory.length - 1;

const input = document.querySelector("input");
if (!input) throw new Error("Input element not found");

const log = document.getElementById("log");
if (!log) throw new Error("Log element not found");

log.innerHTML += `ZeroLimits.dev – Made by <a href="https://github.com/noClaps">noClaps</a>\n`;
log.innerHTML += "Type `help` to see all available commands.\n";

document.addEventListener("click", (ev) => {
  if (/** @type {HTMLElement} */ (ev.target).id === "log") return;
  input.focus();
});

const Commands = {
  whoami() {
    return `\
noClaps – The most interesting boring person you've ever met.

I'm a university graduate with a MSci in theoretical physics. I also enjoy
programming, photography, drawing, music, math, writing and learning.

I also like cats and cookies. Especially cookies.`;
  },

  clear() {
    log.innerHTML = "";
    input.value = "";
  },

  /** @param {string[]} args  */
  help(args) {
    if (args.length > 1) {
      return "Incorrect usage of the `help` command. Use `help help` to see how to use this command.";
    }

    switch (args[0]) {
      case "clear":
        return `\
Usage: clear
Clear the screen`;
      case "help":
        return `\
Usage: help [command]
Display help menu
Arguments:
  [command]  The command to list the help guide for. If this argument is not
             provided, the list of commands and their descriptions is
             displayed.`;
      case "ls":
        return `\
Usage: ls [directory] [--keys]
List contents of directory
Arguments:
  [directory]  The directory for which to list contents for. If this argument
               is not provided, the contents of all directories are listed.
               Directory names end with a backslash (/).
Options:
  --keys       Display the keys of the listed links, so that they can be used
               with the \`open\` command. The keys are displayed in (parentheses)
               at the end of the links.`;
      case "open":
        return `\
Usage: open <key> [--source]
Open link or source in a new tab
Arguments:
  <key>     The key of the link you'd like to open. This will open the link to
            the website by default, unless the project or contact doesn't have
            a website or if the --source flag is used, in which case the link
            to the source will be opened. You can obtain this key from the
            \`ls --keys\` command.
Options:
  --source  Open the link to the source code, even if there is a website link
            available.`.replaceAll("<", "&lt;");
      case "whoami":
        return `\
Usage: whoami
Show details about me`;
      default:
        return `\
Commands:
  clear                    Clear the screen
  help [command]           Display help menu
  ls [directory] [--keys]  List contents of directory
  open <key> [--source]    Open link or source in a new tab
  whoami                   Show details about me`.replaceAll("<", "&lt;");
    }
  },

  /** @param {string[]} args */
  ls(args) {
    if (args.length > 2)
      return "Incorrect usage of the `ls` command. Use `help ls` to see how to use this command.";

    let showKeys = false;
    let idx = -1;
    if ((idx = args.findIndex((a) => a == "--keys")) != -1) {
      showKeys = true;
      args.splice(idx, 1);
    }

    let arg = args[0];

    let contactList = "";
    const contacts = directory.contact;
    Object.keys(contacts).forEach((key, i) => {
      const contact = contacts[key];
      if (i > 0) contactList += "\n";
      contactList += i == Object.keys(contacts).length - 1 ? "└" : "├";
      contactList += `── ${contact.name} - <a href="${contact.link}">${contact["link-name"]}</a>`;
      if (showKeys) contactList += ` (${key})`;
    });

    let projectsList = "";
    const projects = directory.projects;
    Object.keys(projects).forEach((key, i) => {
      const project = projects[key];
      if (i > 0) projectsList += "\n";
      projectsList += i === Object.keys(projects).length - 1 ? "└" : "├";
      projectsList += `── ${project.name} - `;
      if (project.link) projectsList += `<a href="${project.link}">Link</a> - `;
      projectsList += `<a href="${project.source}">Source</a>`;
      if (showKeys) projectsList += ` (${key})`;
      projectsList += `\n${i === Object.keys(projects).length - 1 ? " " : "│"}   ${project.description}`;
    });

    if (!arg)
      return `\
contact/
${contactList}
projects/
${projectsList}`;

    arg = arg.replace(/^\/*|\/*$/g, "");
    if (arg == "contact") return `contact/\n${contactList}`;
    if (arg == "projects") return `projects/\n${projectsList}`;

    return `${arg}: Directory not found`;
  },

  /** @param {string[]} args  */
  open(args) {
    if (args.length < 1 || args.length > 2)
      return "Incorrect usage of the `open` command. Use `help open` to see how to use this command.";

    let key = "";
    let openSource = false;

    if (args.length === 2) {
      if (args[0] === "--source") {
        openSource = true;
        key = args[1];
      }

      if (args[1] === "--source") {
        openSource = true;
        key = args[0];
      }

      if (args[0] !== "--source" && args[1] !== "--source") {
        return "Incorrect usage of the open command. Use `help open` to see how to use this command.";
      }
    } else {
      key = args[0];
    }

    if (key in directory.projects) {
      if (openSource || !directory.projects[key].link) {
        window.open(directory.projects[key].source, "_blank");
        return "";
      }

      window.open(directory.projects[key].link, "_blank");
      return "";
    }

    if (key in directory.contact) {
      if (openSource) {
        return "`--source` flag cannot be used with a contact key.";
      }

      window.open(directory.contact[key].link, "_blank");
      return "";
    }

    if (key === "--source")
      return "A key is needed. Use `help open` to see how to use this command.";

    return `${key}: Unknown key. Use \`ls --keys\` to see available keys.`;
  },

  /** @param {string} command  */
  fallback(command) {
    if (directory.projects[command]) {
      const project = directory.projects[command];
      return `\
${project.name} - ${project.link ? `<a href="${project.link}">Link</a> - ` : ""}<a href="${project.source}">Source</a>
${project.description}`;
    }

    if (directory.contact[command]) {
      const contact = directory.contact[command];
      return `${contact.name} - <a href="${contact.link}">${contact["link-name"]}</a>`;
    }

    if (command === "") return "";

    return "Not a valid command. Type `help` to see all available commands.";
  },
};

input.addEventListener("keyup", (e) => {
  switch (e.key) {
    case "ArrowUp": {
      if (e.key === "ArrowUp") {
        e.preventDefault();
        if (currentPos >= 0) {
          input.value = cmdHistory[currentPos];
          currentPos -= 1;
        }
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

      let returnVal = "";
      const command = cmd.split(" ")[0];
      const args = cmd.split(" ").slice(1);

      switch (command) {
        case "whoami": {
          returnVal = Commands.whoami();
          break;
        }
        case "clear": {
          Commands.clear();
          return;
        }
        case "help": {
          returnVal = Commands.help(args);
          break;
        }
        case "ls": {
          returnVal = Commands.ls(args);
          break;
        }
        case "open": {
          returnVal = Commands.open(args);
          break;
        }
        default:
          returnVal = Commands.fallback(cmd);
      }

      log.innerHTML += `user@zerolimits.dev / > ${input.value}\n`;
      if (returnVal) log.innerHTML += `${returnVal}\n`;

      scrollTo(0, document.body.scrollHeight);
      input.value = "";
    }
  }
});
