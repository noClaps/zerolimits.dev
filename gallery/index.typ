#{
  show image: it => {
    html.img(
      src: str(it.source).replace("./", "gallery/"),
      width: 800,
      alt: it.alt,
      title: it.alt,
    )
  }

  html.html(lang: "en", {
    html.head({
      html.meta(charset: "utf-8")
      html.meta(name: "viewport", content: "width=device-width, initial-scale=1.0")
      html.meta(name: "description", content: "A website to showcase some cool photos I've taken.")
      html.link(rel: "icon", href: "/favicon.png")
      html.link(rel: "stylesheet", href: "/global.css")
      html.style(read("./style.css"))
      html.title[Aperturic Focus]
    })

    html.body({
      html.header({
        html.h1(sym.zws)
        html.nav({
          link("/")[Homepage]
          link("/blog/")[Blog]
        })
      })
      html.main[
        #html.div(class: "title")[
          #html.h1[Aperturic Focus]

          A website to showcase some cool photos I've taken.
        ]

        == 2025

        #html.section({
          image(
            "./assets/2025/PXL_20250805_135159467.RAW-01.COVER.heic",
            alt: "University of Bristol Botanic Garden, Bristol, August 2025",
          )
          image(
            "./assets/2025/PXL_20250805_132917260.RAW-01.COVER.heic",
            alt: "University of Bristol Botanic Garden, Bristol, August 2025",
          )
          image(
            "./assets/2025/PXL_20250805_132650363.RAW-01.COVER.heic",
            alt: "University of Bristol Botanic Garden, Bristol, August 2025",
          )
          image(
            "./assets/2025/PXL_20250805_132408981.PORTRAIT.heic",
            alt: "University of Bristol Botanic Garden, Bristol, August 2025",
          )
          image(
            "./assets/2025/PXL_20250805_132157870.RAW-01.COVER.heic",
            alt: "University of Bristol Botanic Garden, Bristol, August 2025",
          )
          image("./assets/2025/PXL_20250614_120123760.heic", alt: "Bridge of Sighs, Oxford, June 2025, Edited")
          image("./assets/2025/PXL_20250614_124018541.PORTRAIT.heic", alt: "Jubilee Bridge, Oxford, June 2025")
          image(
            "./assets/2025/PXL_20250614_124954246.PORTRAIT.heic",
            alt: "Oxford Botanic Garden, Oxford, June 2025",
          )
          image(
            "./assets/2025/PXL_20250614_125143843.PORTRAIT.heic",
            alt: "Oxford Botanic Garden, Oxford, June 2025",
          )
          image(
            "./assets/2025/PXL_20250614_125204462.PORTRAIT.heic",
            alt: "Oxford Botanic Garden, Oxford, June 2025",
          )
        })

        == 2024

        #html.section({
          image(
            "./assets/2024/PXL_20240913_160912949.RAW-02.ORIGINAL.heic",
            alt: "Durdham Downs, Bristol, September 2024, Edited",
          )
          image(
            "./assets/2024/PXL_20240613_162121693.PORTRAIT-edited.heic",
            alt: "Tullydermot Falls, Ireland, June 2024, Edited",
          )
          image("./assets/2024/PXL_20240612_182802856.PORTRAIT.heic", alt: "Fowley's Falls, Ireland, June 2024")
          image(
            "./assets/2024/PXL_20240612_172302415-edited.heic",
            alt: "Glenade Lough, Ireland, June 2024, Edited",
          )
          image("./assets/2024/PXL_20240612_112117618.PORTRAIT.heic", alt: "Pines Island, Ireland, June 2024")
          image("./assets/2024/PXL_20240611_200458046.PORTRAIT.heic", alt: "The Burren, Ireland, June 2024")
          image(
            "./assets/2024/PXL_20240611_183918184-edited.heic",
            alt: "Cliffs of Moher, Ireland, June 2024, Edited",
          )
          image("./assets/2024/PXL_20240611_115028042.heic", alt: "Dunquin Pier, Ireland, June 2024")
          image("./assets/2024/PXL_20240610_154501973-edited.heic", alt: "Kerry Cliffs, Ireland, June 2024, Edited")
          image("./assets/2024/PXL_20240609_165604773-edited.heic", alt: "Brow Head, Ireland, June 2024, Edited")
          image("./assets/2024/PXL_20240609_165233335-edited.heic", alt: "Brow Head, Ireland, June 2024, Edited")
          image(
            "./assets/2024/PXL_20240608_093910483-edited.heic",
            alt: "Glen Beach Cliff Walk, Ireland, June 2024, Edited",
          )
          image(
            "./assets/2024/PXL_20240608_091905178.PORTRAIT.heic",
            alt: "Glen Beach Cliff Walk, Ireland, June 2024",
          )
          image("./assets/2024/PXL_20240608_075148772.PORTRAIT.heic", alt: "Glendalough, Ireland, June 2024")
          image("./assets/2024/PXL_20240608_074950847.PORTRAIT.heic", alt: "Glendalough, Ireland, June 2024")
          image("./assets/2024/PXL_20240608_074910507.PORTRAIT.heic", alt: "Glendalough, Ireland, June 2024")
          image("./assets/2024/PXL_20240608_074829252.PORTRAIT.heic", alt: "Glendalough, Ireland, June 2024")
          image("./assets/2024/PXL_20240607_134219707-edited.heic", alt: "Sally Gap, Ireland, June 2024, Edited")
          image("./assets/2024/PXL_20240607_134140004-edited.heic", alt: "Sally Gap, Ireland, June 2024, Edited")
          image(
            "./assets/2024/PXL_20240607_122433917-edited.heic",
            alt: "Ballinastoe Woods, Ireland, June 2024, Edited",
          )
          image("./assets/2024/PXL_20240607_084055615-edited.heic", alt: "Dublin, June 2024, Edited")
          image("./assets/2024/PXL_20240302_153044811.heic", alt: "Stonehenge, March 2024, Edited")
        })

        == 2023

        #html.section({
          image(
            "./assets/2023/PXL_20230626_173158003.PORTRAIT.heic",
            alt: "Isle of Skye, Scotland, June 2023, Edited",
          )
          image(
            "./assets/2023/PXL_20230626_172617550.PORTRAIT.heic",
            alt: "Isle of Skye, Scotland, June 2023, Edited",
          )
          image("./assets/2023/PXL_20230626_170441424.heic", alt: "Isle of Skye, Scotland, June 2023, Edited")
          image("./assets/2023/PXL_20230626_165940734.heic", alt: "Isle of Skye, Scotland, June 2023, Edited")
          image("./assets/2023/PXL_20230626_164639993.heic", alt: "Isle of Skye, Scotland, June 2023, Edited")
          image("./assets/2023/PXL_20230626_162004437.heic", alt: "Isle of Skye, Scotland, June 2023, Edited")
          image("./assets/2023/PXL_20230626_114222563.heic", alt: "Isle of Skye, Scotland, June 2023, Edited")
          image("./assets/2023/PXL_20230625_150852157.heic", alt: "Scotland, June 2023, Edited")
          image("./assets/2023/PXL_20230619_162022753.MP.heic", alt: "St Ives, England, June 2023, Edited")
          image("./assets/2023/PXL_20230619_102727661.PORTRAIT.heic", alt: "St Michael's Mount, England, June 2023")
          image("./assets/2023/PXL_20230619_102522649.MP.heic", alt: "St Michael's Mount, England, June 2023")
          image("./assets/2023/PXL_20230619_102419973.heic", alt: "St Michael's Mount, England, June 2023")
          image("./assets/2023/PXL_20230617_181608079.heic", alt: "White Cliffs of Dover, England, June 2023")
          image("./assets/2023/PXL_20230617_155559555.heic", alt: "Dover Castle, England, June 2023, Edited")
          image("./assets/2023/PXL_20230617_134827197.heic", alt: "Canterbury, June 2023, Edited")
          image("./assets/2023/PXL_20230617_133957428.PORTRAIT.heic", alt: "Canterbury, June 2023, Edited")
          image("./assets/2023/PXL_20230617_133954035.PORTRAIT.heic", alt: "Canterbury, June 2023, Edited")
          image("./assets/2023/PXL_20230617_133836993.PORTRAIT.heic", alt: "Canterbury, June 2023, Edited")
          image("./assets/2023/PXL_20230617_133749683.PORTRAIT.heic", alt: "Canterbury, June 2023, Edited")
          image("./assets/2023/PXL_20230615_120711635.PORTRAIT.heic", alt: "Greenwich, June 2023, Edited")
          image("./assets/2023/PXL_20230403_161749050.heic", alt: "Bristol, April 2023")
          image("./assets/2023/PXL_20230403_160607185.PORTRAIT.heic", alt: "Bristol, April 2023")
          image("./assets/2023/PXL_20230403_153954388.PORTRAIT.ORIGINAL.heic", alt: "Bristol, April 2023")
          image("./assets/2023/PXL_20230321_133544707.PORTRAIT.heic", alt: "Bristol, March 2023")
          image("./assets/2023/PXL_20230321_133251194.PORTRAIT.heic", alt: "Bristol, March 2023")
          image("./assets/2023/PXL_20230304_140223994.heic", alt: "Bath, March 2023")
          image("./assets/2023/PXL_20230120_171121215.heic", alt: "Bristol, January 2023")
        })

        == 2022

        #html.section({
          image("./assets/2022/PXL_20221220_143425546.heic", alt: "Greenwich, London, December 2022")
          image(
            "./assets/2022/PXL_20221220_112332250.PORTRAIT.heic",
            alt: "Kensington Gardens, London, December 2022",
          )
          image(
            "./assets/2022/PXL_20221220_110410061.PORTRAIT.heic",
            alt: "Royal Albert Hall, London, December 2022",
          )
          image(
            "./assets/2022/PXL_20221220_104453838.PORTRAIT.heic",
            alt: "Kensington Gardens, London, December 2022",
          )
          image(
            "./assets/2022/PXL_20221220_104045055.PORTRAIT.heic",
            alt: "Kensington Gardens, London, December 2022",
          )
          image("./assets/2022/PXL_20221219_195901141.heic", alt: "London, December 2022")
          image("./assets/2022/PXL_20221219_195445793.heic", alt: "London, December 2022")
          image("./assets/2022/PXL_20221219_184645596.heic", alt: "Picadilly Circus, London, December 2022")
          image("./assets/2022/PXL_20221219_144657590.heic", alt: "Baker Street, London, December 2022")
          image("./assets/2022/PXL_20221219_133355557.heic", alt: "London, December 2022")
          image("./assets/2022/PXL_20221219_133137100.heic", alt: "Big Ben, London, December 2022")
          image("./assets/2022/PXL_20221219_131541762.heic", alt: "The Shard, London, December 2022")
          image("./assets/2022/PXL_20221219_124001547.heic", alt: "London, December 2022")
          image("./assets/2022/PXL_20221219_123839571~2.heic", alt: "London, December 2022")
          image("./assets/2022/PXL_20221219_113743469.heic", alt: "London, December 2022")
          image("./assets/2022/PXL_20221219_104648927.heic", alt: "Buckingham Palace, London, December 2022")
          image("./assets/2022/PXL_20221119_172624803.PORTRAIT.heic", alt: "Bristol, November 2022")
          image("./assets/2022/PXL_20221119_171942774.PORTRAIT.heic", alt: "Bristol, November 2022")
          image("./assets/2022/PXL_20221112_195655017.heic", alt: "Bristol, November 2022")
          image("./assets/2022/PXL_20221112_195101072~2.heic", alt: "Bristol, November 2022")
          image("./assets/2022/PXL_20221112_192252937.heic", alt: "Bristol, November 2022")
          image("./assets/2022/PXL_20221008_154916037.PORTRAIT.heic", alt: "Bristol, October 2022")
          image("./assets/2022/PXL_20221008_154446021.PORTRAIT.heic", alt: "Bristol, October 2022")
          image("./assets/2022/PXL_20221008_154416467.PORTRAIT.heic", alt: "Bristol, October 2022")
          image("./assets/2022/PXL_20221008_154259419.heic", alt: "Bristol, October 2022")
          image("./assets/2022/PXL_20221008_153624562.PORTRAIT.heic", alt: "Bristol, October 2022")
          image("./assets/2022/PXL_20221008_145550360.PORTRAIT.heic", alt: "Bristol, October 2022")
          image("./assets/2022/PXL_20221008_145459220.PORTRAIT.heic", alt: "Bristol, October 2022")
          image("./assets/2022/PXL_20220926_214608648.heic", alt: "Bristol, September 2022")
          image("./assets/2022/PXL_20220926_202746506~2.heic", alt: "Bristol, September 2022")
          image("./assets/2022/53.heic", alt: "Singapore, May 2022")
          image("./assets/2022/52.heic", alt: "Singapore, May 2022")
          image("./assets/2022/51.heic", alt: "Singapore, May 2022")
          image("./assets/2022/50.heic", alt: "Singapore, May 2022")
          image("./assets/2022/49.heic", alt: "Singapore, May 2022")
          image("./assets/2022/48.heic", alt: "Singapore, May 2022")
          image("./assets/2022/47.heic", alt: "Singapore, April 2022")
          image("./assets/2022/46.heic", alt: "Singapore, April 2022")
          image("./assets/2022/45.heic", alt: "Singapore, March 2022")
          image("./assets/2022/44.heic", alt: "Singapore, March 2022")
          image("./assets/2022/43.heic", alt: "Singapore, March 2022")
          image("./assets/2022/42.heic", alt: "Singapore, March 2022")
          image("./assets/2022/41.heic", alt: "Singapore, March 2022")
          image("./assets/2022/40.heic", alt: "Singapore, March 2022")
          image("./assets/2022/39.heic", alt: "Singapore, March 2022")
          image("./assets/2022/38.heic", alt: "Singapore, March 2022")
          image("./assets/2022/37.heic", alt: "Singapore, March 2022")
          image("./assets/2022/36.heic", alt: "Singapore, March 2022")
          image("./assets/2022/35.heic", alt: "Singapore, March 2022")
          image("./assets/2022/34.heic", alt: "Singapore, March 2022")
          image("./assets/2022/33.heic", alt: "Singapore, March 2022")
          image("./assets/2022/32.heic", alt: "Singapore, March 2022")
          image("./assets/2022/31.heic", alt: "Singapore, March 2022")
          image("./assets/2022/30.heic", alt: "Thailand, March 2022")
          image("./assets/2022/29.heic", alt: "Thailand, March 2022")
          image("./assets/2022/28.heic", alt: "Thailand, March 2022")
          image("./assets/2022/27.heic", alt: "Thailand, March 2022")
          image("./assets/2022/26.heic", alt: "Thailand, March 2022")
          image("./assets/2022/25.heic", alt: "Thailand, March 2022")
          image("./assets/2022/24.heic", alt: "Thailand, March 2022")
          image("./assets/2022/23.heic", alt: "Thailand, March 2022")
          image("./assets/2022/22.heic", alt: "Thailand, March 2022")
          image("./assets/2022/21.heic", alt: "Thailand, March 2022")
          image("./assets/2022/20.heic", alt: "Thailand, March 2022")
          image("./assets/2022/19.heic", alt: "Thailand, March 2022")
          image("./assets/2022/18.heic", alt: "Thailand, March 2022")
          image("./assets/2022/16.heic", alt: "Thailand, March 2022")
          image("./assets/2022/15.heic", alt: "Thailand, March 2022")
          image("./assets/2022/14.heic", alt: "Thailand, March 2022")
          image("./assets/2022/13.heic", alt: "Thailand, March 2022")
          image("./assets/2022/12.heic", alt: "Thailand, March 2022")
          image("./assets/2022/11.heic", alt: "Thailand, February 2022")
          image("./assets/2022/10.heic", alt: "Thailand, February 2022")
          image("./assets/2022/9.heic", alt: "Thailand, February 2022")
          image("./assets/2022/8.heic", alt: "Thailand, February 2022")
          image("./assets/2022/7.heic", alt: "Thailand, February 2022")
          image("./assets/2022/6.heic", alt: "Thailand, February 2022")
          image("./assets/2022/5.heic", alt: "February 2022")
          image("./assets/2022/4.heic", alt: "February 2022")
          image("./assets/2022/3.heic", alt: "Singapore, February 2022")
        })

        == 2019

        #html.section({
          image("./assets/2019/IMG_9573.heic", alt: "Indonesia, June 2019, Edited")
          image("./assets/2019/IMG_9042.heic", alt: "Indonesia, June 2019, Edited")
          image("./assets/2019/IMG_9041.heic", alt: "Indonesia, June 2019, Edited")
          image("./assets/2019/IMG_9013.heic", alt: "Indonesia, June 2019, Edited")
          image("./assets/2019/IMG_0292.heic", alt: "Indonesia, June 2019, Edited")
          image("./assets/2019/IMG_0252.heic", alt: "Indonesia, June 2019, Edited")
          image("./assets/2019/IMG_0217.heic", alt: "Indonesia, June 2019, Edited")
          image("./assets/2019/IMG_0182.heic", alt: "Indonesia, June 2019, Edited")
          image("./assets/2019/IMG_0084.heic", alt: "Indonesia, June 2019, Edited")
        })
      ]
    })
  })
}
