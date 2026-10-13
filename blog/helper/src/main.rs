use std::{collections::BTreeMap, env::args};

use irosashi::{CodeToHtmlOptions, CodeToTokensOptions, DefaultColor, Highlighter, HtmlOptions};

fn main() {
    let mut args = args().skip(1);
    let lang = args.next().unwrap();
    let code = args.next().unwrap();

    let hl = Highlighter::new().unwrap();
    let opts = CodeToHtmlOptions {
        tokens: CodeToTokensOptions::new(&lang, ""),
        themes: BTreeMap::from([
            ("light".into(), "github-light-default".into()),
            ("dark".into(), "github-dark-default".into()),
        ]),
        html: HtmlOptions {
            default_color: DefaultColor::LightDark,
            ..Default::default()
        },
    };
    let html = hl.code_to_html(&code, &opts).unwrap();
    print!(
        "{}",
        html.replace(r#" class="iro iro-themes dark light" style="background-color:light-dark(#ffffff, #0d1117);color:light-dark(#1f2328, #e6edf3)" tabindex="0""#, "")
    );
}
