---
date: 2026-11-03
---

I recently read [eva's post](https://eva.ac/blog/llms/) about the current state of LLMs, and it got me thinking about my own usage of LLMs and the broader LLM and tech industry. Consider this a sequel to [My takes on AI](/blog/my-takes-on-ai).

## How I use LLMs

Since my last post about LLMs, I've tried using them a couple times. I don't think I used LLMs all that much throughout 2025, and I think I ended up deleting my Claude account shortly after I published that post. I ended up getting an OpenAI subscription for a month after I finished exams in May 2026 just to try it out, and it resulted in about similar disappointment as I'd faced in 2025. The models just weren't good at what I was trying to do, and like any good craftsperson, I'm choosing to blame the tools instead of my own skill.

> [!note]
>
> I think blaming LLMs for not being good at understanding instructions is a perfectly reasonable thing to do. As I pointed out in my previous post, large _language_ models were primarily built to understand human language, which includes instruction following. Failure to do so is therefore a failure of the tool, and not a failure of the person using it. I shouldn't have to jump through hoops and weird conventions that change every 3 months to get the LLM to understand what I'm saying. It should _just work_.

However, I did notice an improvement in the quality of the LLMs, and how far they were able to get before inevitably falling apart. One especially good use case I found for them was search, where there was just too much detail needed to fit neatly into a regular search box. So I re-enabled [Kagi Assistant](https://help.kagi.com/kagi/ai/assistant.html), and starting using that as a fallback for some of my more advanced queries where I couldn't quite formulate a good search query for a regular search.

> [!note]
>
> I'm still not a fan of the chat interface for LLMs, and I think there's a nicer middle ground specifically for searching where I'm able to enter my search query as a question I'd ask an LLM, and it would be able to give me a list of results like search engines do, rather than just telling me the "answer" directly. I've put "answer" in quotes here because oftentimes the sources that the LLM pulls the answer from will have some additional nuance or detail that it'll miss completely that's usually important to solving the problem I was having, so while it might give me part of the solution, it's usually not the whole solution I'm looking for.

I also starting using LLMs for writing things I found boring, like CVs, cover letters, and emails for job applications. I'm not sure why we've decided as a collective to make these things the most dull pieces of writing on the planet given they're supposed to highlight a candidate's skills and abilities, and probably some part of their personality. But if it'll get me a job, I'll do it. Rest assured, all of my other writing, including this blog, is entirely written by me, because if I didn't enjoy doing it anymore I'd have stopped.

My final use case for LLMs is one that I picked up recently and is the main thing I wanted to highlight in this post: coding.

## All work and no play

I think most things people do can be broadly categorised into either "work" or "play". I know there's a lot of nuance and stuff in between, but hear me out here.

I'm defining **work** as the stuff you do but don't care much for. This is the stuff that, if it disappeared tomorrow with no other impact on your life, you'll probably feel something in the range of not caring at all to being quite happy that it's gone. On the other hand, **play** is the stuff you enjoy doing, where you'd be unhappy if you weren't able to do it anymore.

The labels I'm using here are just labels. Where each of your activities lies on this scale is entirely up to you. You might find what you do for work enjoyable and something you do outside of that boring. In that case, your work would be your "play" and your other activity might be your "work".

![A diagram of the work-play scale. If your general outlook towards an activity is more positive, falls under "play". Otherwise, it's "work".](work-play-scale.svg)

I think most people would be quite content with having their work somewhat automated away, provided they didn't face any consequences for it, so they could have more time for play. At the same time, people are vehemently against having their play taken away from them, even if that play looks like work to someone else.

My own example of this is whenever I bring up math or programming as a hobby, people always dismiss it, because in their eyes those things are work and I'm weird for liking them. There's a strange idea that the science/tech is work and the arts are hobbies, so if your preferences are the other way around you're weird. I like art, I have a [photo gallery](/gallery/) because I enjoy doing photography and sharing it. I like singing, even though I'm not very good at it. I like writing poetry and drawing, even though I don't do those very often either. But my favorite thing to do is problem-solving, which is exactly what math and programming are for me.

The mistake a lot of companies made was shoving LLMs into the places people go for play, while ignoring a lot of the work. Image generation, for instance, caused such an uproar because most of the people who do photography and digital art enjoy it, so taking that away from them is obviously going to make them upset. I think this is how eva and a lot of others, myself included, see the work/projects they do.

On the other hand, people who work a 9–5 writing boring boilerplate code all day aren't going to complain as much if a tool like an LLM can do it for them so long as they get to keep their jobs. For them, the work they do isn't intellectually stimulating, and they just see it as a means to an end. The faster their work gets done, the more free time they have to do things they actually enjoy.

The balance I've found for myself is to only use LLMs for the latter.

Usually, figuring out and implementing a solution is the fun part. That's when I'll sit down and code up a solution in whatever programming language(s) I'm interested in using at the time. I try not to use LLMs for this process unless I'm truly stuck and search results aren't helping me out, and even then it's usually to solve the specific thing I'm stuck on, and I try to understand _why_ the solution it gave me worked, and if I can come up with a better solution myself building on the idea.

Other times, I just want a working solution that does a specific thing I want, and I'm not interested in how it works. This is when I reach for pre-existing solutions, because even if they don't work 100% how I'd like them to, it's _good enough_ for something I can't be bothered to build myself. That is, up until a few days ago.

## The LLMs got good

Using [Claude Opus 5.5](https://www.anthropic.com/claude-opus-5-5) these last few days got me thinking about those one-off, good-enough solutions again.

The problem I wanted solved was to have a single-binary solution to building my blog and [TIL](/til/) posts from Obsidian Markdown to an HTML fragment, along with good syntax highlighting and LaTeX to MathML rendering, and a few more features. My working solution to this was [Pandoc](https://pandoc.org) with some Lua filters and Python post-processing, and a custom Go syntax highlighter using [shiki-go](https://github.com/ralscha/shiki-go), but I wasn't a fan of this setup. So I asked Claude to build what I was looking for and it gave me [blackrock](https://github.com/noClaps/blackrock), which I'm currently using. It's much faster than the Pandoc setup and I can customise it to my heart's desire.

I also wanted to optimise my images losslessly, but I'd need to install a different CLI for each image type ([Oxipng](https://github.com/oxipng/oxipng) for PNGs, [OXVG](https://github.com/noahbald/oxvg) for SVGs, [MozJPEG](https://github.com/mozilla/mozjpeg) for JPEGs, etc.), some with their own further dependencies. Ideally I'd have support for all the different image types in one single program. So I repurposed my [imgoptim](https://github.com/noClaps/imgoptim) project for this, handed it off to Claude, and it [reduced the sizes of my images](https://codeberg.org/noClaps/zerolimits.dev/commit/18237bac8e922f8db5e7f1746f49417b237ebab6) quite significantly with no visible differences.

I also tried using Opus 5.5 for a slightly [larger-scale project](https://github.com/noClaps/highlights) and, as predicted, it fell apart pretty quickly and took like half of my weekly usage with it. Maybe that's because I wasn't very clear on the direction of the project myself because I wasn't particularly interested in it, or maybe because the model isn't there yet, I don't know. I think it works, but I haven't actually tested it to make sure.

Blackrock and imgoptim are both projects I probably wouldn't have bothered to make pre-LLMs, at least not until I got really fed up with my existing solutions. But now, I get to have my cake (the projects exist) and eat it too (I didn't have to make them)! Both projects are currently unlicensed because the licensing of LLM-generated code is still up in the air, and I'm not particularly interested "properly" open sourcing these projects anyway. I haven't looked at the code for either one very closely and while I'm sure I'd be able to find lots of mistakes and bad decisions if I did, I'm not willing to do so because it works fine for me and that's mainly what I care about. They're also not in the projects list on my [homepage](/) because I don't consider them _my_ projects, or at least not ones that I'm willing to show off.

## Predictions

I think tools like LLMs will become more and more ingrained in our daily lives, though I don't think they'll be as prominent as they are right now. Eventually they'll get to a point where they'll just become a standard part of the toolkit that a lot of people use and even begin to expect, especially as open-weight models get better.

One thing I've noticed is the recent focus on token efficiency. My guess is that all the compute these companies were using is starting to become a limiting factor, and they need a way to offer their services without requiring nearly as much if they don't want to go bankrupt. They can't dumb down the models because then people will complain and go to one of their competitors, so the next best option is to try and get more out of every token. That's why something like [GPT 6.1 Sol](https://openai.com/index/introducing-gpt-6-1-sol/) can have "Near-Astra intelligence for a fifth of the price". I think this trend will continue for a while, with newer models being more and more token-efficient.

I think another thing is the integration of LLMs in other applications, rather than being standalone applications of their own. This is already happening, especially with programming tools like editors, IDEs, terminals, etc., but I think a lot of people are realising that chat isn't the best interface to work with LLMs, and they work better when integrated with existing apps and programs. I actually think Apple could be the one that brings this workflow to the masses, if they can ever get their stuff together with Siri AI and Apple Intelligence.

For coding specifically, I think LLMs will eventually become free and integrated directly into IDEs rather than being external plugins. This kind of leads from the previous two predictions, but specifically for dev tooling, we've seen this kind of pattern before. A new technology comes out and it's paywalled for a few years, then someone makes a good open source implementation of it and gives it away for free, and now everyone is forced to do the same because the expectation has been set. Compilers, syntax highlighting, code completions, even operating systems all used to be paid until a free version came along and set a new expectation.

These are my predictions about LLMs and the tech industry for the next decade or so. Maybe I end up being right, maybe I end up being wrong, maybe it doesn't matter by then because the world has ended, who can say?

## Conclusion

I guess the point I'm trying to make is that, as the title says, LLMs are different now, and I think they'll keep changing both in their own capabilities and the way people use and think about them. I'm not telling you to "adapt to this new world or get left behind", because that doesn't make any sense. There's not a "new world", nor is there anything to "get left behind". We're all still living on the same planet in the same time period, everyone just has slightly different preferences about which tools they use and when they choose to use them, as we always have.

LLMs are a cheap(-ish) shortcut. The same way you wouldn't tell a craftsman to "get with the times" for rejecting mass production and hand-crafting their own pieces, it doesn't make sense to tell someone who doesn't want to use LLMs to "get with the times" just because you're willing to take a shortcut that they aren't.

I'm also not against using LLMs where it makes sense. We have a finite amount of time to live our lives, sometimes taking that shortcut is worth it if it grants you more time to do the things you enjoy, so long as you recognise the trade-off of taking that shortcut.

Happy crafting :)