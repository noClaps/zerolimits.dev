---
date: 2026-05-24
slug: promises
---

> [!note]
>
> I want to preface this by saying that I'm by no means an expert on this topic, I'm just writing my observations from the point of view of a consumer.

There's a trend I've noticed over the the years, having seen so many companies and products fall in and out of favor with the general public. It explains why there's such a negative view on so-called "updates" that are supposed to make the experience better, but often end up ruining it for the people using these products. There's probably a more formal name for this phenomenon, but I like to call it "core promises".

## Making promises

When you make a product for others to use, you implicitly create a set of core promises about that product to the people who use it. Oftentimes, this goes unnoticed, because the promise is upheld and everyone is happy with the way things are. For instance, when you sign up for an email account, like Gmail, you go in with the expectation that you're going to get a well-designed and reliable interface to interact with your email. And that's a promise that Google has managed to keep for a very long time, which is why most people never notice. Everything _just works_.

To be clear, this is a good thing. The tools you use daily should not stand out as being extraordinary, they should blend in, stay out of the way, and be extra-_ordinary_. A flashy feature now will usually end up either fading away into the background or becoming an annoyance later. However, the issues truly arise when those core promises get broken.

## Breaking promises

These core promises are usually aligned with the vision that the creators have for the project. The stronger the vision, the more likely it is that the promises will be maintained. If all I have is a very vague idea of what I'm trying to build, my product isn't going to be very focused in its goal, and will probably end up being a worse version of what already exists. On the other hand, if I know exactly what I'm trying to build, it's usually because it's a problem I've thought deeply about, enough to identify what solutions already exist, and what's missing from them that my product can solve.

However, sometimes things change. Founders move on to other projects, CEOs retire or get fired, people lose interest, and they get replaced by someone who may have their own ideas and skills, but don't have the same vision for the product. What the original creator saw as a feature, the new leader may see as a bug. This is often the situation when one of those core promises gets broken.

By breaking a core promise, you end up causing problems for a significant portion of your userbase, usually the power users who by this point probably know the ins and outs of your system better than you do. These are the people who would otherwise recommend your product to their friends and family, and talk about it on social media. Because of their deep understanding of your product, they probably know exactly what features people care about, likely far better than your marketing team ever will.

This is also the same group of people who will look at your breaking changes and understand immediately what the effects of those changes are going to be. They'll get mad at you for messing up their workflows, and then they're going to broadcast that information to everyone they know. In other words, this is the last group of people you want to make upset. It is also the first group of people that will be upset if you break a core promise.

If you've ever wondered why people seem to hate updating their software, or buying newer versions of things that are supposedly "upgraded", this is why. There's usually something in the newer version that works fundamentally differently to the old one, and that ends up breaking people's workflows.

## Case studies

### Google Search

A great example of this is Google Search. Search used to be a widely beloved and praised service, far better in quality than any of its competitors. It got to the point that Google became synonymous with "searching"; you'd "google" stuff you wanted to find out. One of their core promises was delivering **accurate** results.

This was first broken when Google introduced sponsored results. Suddenly, you didn't need to produce high quality content to get higher rankings on Google Search, you just needed to have deep enough pockets. At first, it was mostly larger companies paying to have their websites listed first, but pretty quickly scammers realised they could pay a little money to get their scam site to the top of search results, where it would be far more likely for someone to click on it.

Through years of providing high quality search results, Google Search had built up a reputation of providing trustworthy links, and that trust quickly eroded. Of course, since Google makes money from these ads, they have little reason to do something about it, but it does mean that there's a not-insignificant number of people (including me!) who have switched away from Google Search to a different search engine.

The second time Google broke this promise was when they decided to pivot to using LLMs to summarise search results. In theory this was a great idea, Google has a _lot_ of data for their LLMs to train on, and it gets people the relevant information they're looking for much faster for the vast majority of queries. In practice, however... well, [the headlines speak for themselves](https://www.bbc.co.uk/news/articles/cd11gzejgz4o).

### Reddit

One of Reddit's greatest strengths was its openness. Though there are pros and cons to its various communities, it had always been an open platform that allowed anyone to contribute to the vast ecosystem. A major sign of this was the Reddit API, which allowed anyone to use it for free to build their own competitor to the official Reddit app and website. In fact, Reddit's own iOS app originally started out as a third-party app called Alien Blue, which they [acquired in 2014](https://techcrunch.com/2014/10/15/reddit-acquires-alien-blue-the-most-popular-unofficial-reddit-app/). The app eventually got replaced in 2016 with a new one written completely from scratch.

> Our whole philosphy has been to give our users choice. We’ve got the reddit AMA app, and alienblue coming out… but we really want users to use whatever they want.
>
> — [Ellen Pao, Reddit’s head of Strategic Partnerships](https://techcrunch.com/2014/10/15/reddit-acquires-alien-blue-the-most-popular-unofficial-reddit-app/)

This **openness** was one of Reddit's core promises. It allowed other developers to compete with one another and Reddit themselves to provide the best experience for their users. However, in April 2023, Reddit decided to [start charging for API access](https://www.reddit.com/r/reddit/comments/12qwagm/an_update_regarding_reddits_api/), following Twitter's decision to do the same, because it was being used by companies like Google and OpenAI to train their LLMs. This also had the consequence of pricing out third-party apps, including popular ones like [Apollo](https://apolloapp.io).

Not only were these the preferred experiences for millions of Reddit users, in some cases they _needed_ these apps for [accessibility reasons](https://www.reddit.com/r/Blind/comments/14nzwkm/they_finally_did_it_reddit_made_it_impossible_for/). The outrage from this change led to many subreddits protesting, including blackouts, restricting content, and NSFW labels. A lot of people left Reddit due to the effects of this change, and it has caused a major downturn in Reddit's public image.

### GitHub

Although people have been wary of GitHub since it's [acquisition by Microsoft in 2018](https://news.microsoft.com/source/2018/06/04/microsoft-to-acquire-github-for-7-5-billion), the vast majority of programmers still happily used it for hosting their code. This was because, despite Microsoft's reputation, GitHub was still able to maintain its core promise of **reliability**. It was almost always available, and although the UI was slow at times, all of its features generally _just worked_.

However, this began to change in August 2025, when GitHub's then-CEO [Thomas Dohmke stepped down](https://github.blog/news-insights/company-news/goodbye-github/), and instead of hiring a new CEO, [Microsoft merged GitHub into CoreAI](https://www.axios.com/2025/08/11/github-ceo-dohmke-step-down). This was followed by months of GitHub pushing AI features onto their users, but more importantly, serious hits to their reliability as a platform.

GitHub's uptime took a nosedive, [dropping below 99.9% uptime](https://www.theregister.com/software/2026/02/10/github-seems-to-be-struggling-with-three-nines-availability/4881718), the standard for good uptime for online services. This meant that developers couldn't reliably reach their code or other parts of the GitHub platform that they were using. Additionally, there was an incident on 23 April 2026 that resulted in [pull requests being merged incorrectly](https://www.githubstatus.com/incidents/zsg1lk7w13cf), which meant that certain code changes were sometimes being permanently deleted from GitHub when other changes were added.

All of this, and other issues, resulted in a massive outrage from GitHub's userbase, and resulted in many projects and developers looking for alternatives that would allow them to reliably get their work done, including [some of GitHub's earliest and most passionate users](https://mitchellh.com/writing/ghostty-leaving-github) and [very large projects with hundreds of contributors](https://ziglang.org/news/migrating-from-github-to-codeberg/).

## Conclusion

There's plenty of other examples of companies both keeping and breaking their core promises, and the effects of those decisions. The main point I'm trying to make is that if you have a product meant for other people to use, understand it and why your audience cares about and uses it. Breaking changes are fine, and often necessary, to make, but the original vision for the product shouldn't change; those are the core promises you make to your users. Don't break your promises.
