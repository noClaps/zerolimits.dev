---
title: Infinities are weird and fun
date: 2026-11-23
---
Given the name of my site is ZeroLimits, I figured it was about time we talk about infinities.

You've probably heard of infinity before as the "largest number" or something along those lines. That might make sense at first glance, but the definition breaks down pretty quickly if you think about it. How can there be a largest number? Can't you just add 1?

Indeed, you can:

$$
\infty + 1 = \infty
$$

That makes no sense. Using normal arithmetic, that would mean you could subtract ${}\infty{}$ from both sides and get:

$$
\begin{aligned}
\infty+1 & = \infty \\
\infty+1-\infty & = \infty-\infty \\
1 & = 0
\end{aligned}
$$

which we know is nonsensical. So what's going on?

Well we made a pretty strong assumption about the nature of ${}\infty{}$, which is that ${}\infty-\infty = 0{}$, which we can very clearly see from the first line that isn't true:

$$
\begin{aligned}
\infty+1 & = \infty \\
1 & = \infty-\infty
\end{aligned}
$$

But we could have replaced 1 with any number, including infinity, and the equation would've held true. So clearly infinity isn't like most numbers.

In fact, **infinity is not a number at all**, but the idea that something goes on forever and ever and ever.

## Countable infinity

But how do we _know_ something truly goes on forever, rather than just going for a really long time and then stopping. Well one option would be to start counting it, and if we stop counting at some point then whatever we were counting must be finite. Let's start with the whole (or natural) numbers, denoted ${}\mathbb{N}{}$:

$$
\mathbb{N} = \{ 0, 1, 2, 3, 4, \dots \}
$$

These are probably the numbers you're most familiar with, and you're probably aware that they go on forever. The size of the set of natural numbers ${}|\mathbb{N}| = \infty{}$, meaning this set is infinite. Specifically, this set is **countably infinite**, because you can count the elements in the set by, well, the numbers in the set. We can map the elements of this set to the natural numbers, which just means we can list them out in an ordered list. Pretty easy given these are the natural numbers.

$$
\begin{aligned} \\
\mathbb{N} & \mapsto \mathbb{N} \\
0 & \mapsto 0 \\
1 & \mapsto 1 \\
2 & \mapsto 2 \\
3 & \mapsto 3 \\
4 & \mapsto 4 \\
\vdots \\
n & \mapsto n
\end{aligned}
$$

The real fun begins when we try finding the size of the set of even numbers, let's call it ${}\mathcal{E}{}$:

$$
\mathcal{E} = \{ 0, 2, 4, 6, 8, 10, \dots \}
$$

You'd think this would be half the size of the natural number set, given we're only including half the natural numbers by excluding all the odd numbers. However, we can map every element in ${}\mathcal{E}{}$to a natural number:

$$
\begin{aligned}
\mathbb{N} & \mapsto \mathcal{E} \\
0 & \mapsto 0 \\
1 & \mapsto 2 \\
2 & \mapsto 4 \\
3 & \mapsto 6 \\
\vdots \\
n & \mapsto 2n
\end{aligned}
$$

That's just multiplying by two. However, it also means that the size of the set of even numbers is exactly equal to the size of the set of natural numbers. _There are just as many even numbers as natural numbers!_ Isn't that crazy? It's the same thing for the odd numbers:

$$
\begin{aligned}
0 & \mapsto 1 \\
1 & \mapsto 3 \\
2 & \mapsto 5 \\
3 & \mapsto 7 \\
\vdots \\
n & \mapsto 2n+1
\end{aligned}
$$

Again, there are _exactly the same amount of odd numbers as natural numbers!_ If you do the arithmetic directly:

$$
\begin{aligned}
\text{size of } \mathbb{N} & =\infty \\
\text{size of } \mathcal{E} & =\frac{\mathbb{N}}{2} = \frac{\infty}{2} = \infty
\end{aligned}
$$

If we now add the negative numbers, we get the set of integers:

$$
\mathbb{Z} = \{ \dots, -3, -2, -1, 0, 1, 2, 3, \dots \}
$$

Again, it might seem intuitive to say this is twice as big as the natural number set, given we have a whole negative number line to cover. We also can't really start counting it from the smallest number, given we'd have to go all the way to negative infinity. So is this still countably infinite?

Yes! We just have to get slightly creative with how we count:

$$
\begin{aligned}
0 & \mapsto 0 \\
1 & \mapsto -1 \\
2 & \mapsto 1 \\
3 & \mapsto -2 \\
4 & \mapsto 2 \\
\vdots \\
n & \mapsto (-1)^{n} \left\lceil  \frac{n}{2}  \right\rceil 
\end{aligned}
$$

There are just as many integers are there are whole numbers as there are even numbers! The next biggest common set is the set of rational numbers ${}\mathbb{Q}{}$, which is basically just all the possible combinations of two integers in disguise since ${}\frac{n}{m}{}$ can be written as a pair ${}(n, m){}$, where ${}n{}$ and ${}m{}$ are integers.

We can simplify this a bit by considering only the positive rational numbers (meaning ${}n{}$ and ${}m{}$ are natural numbers), and just interpolating them with the negative ones like we did for the integers. But how do you go about counting a pair of infinite sets?

First, let's make a table to generate all the rational numbers:

|     | 1   | 2   | 3   | 4   | 5   | 6   | ... | n   |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1   | 1/1 | 2/1 | 3/1 | 4/1 | 5/1 | 6/1 | ... | n/1 |
| 2   | 1/2 | 2/2 | 3/2 | 4/2 | 5/2 | 6/2 | ... | n/2 |
| 3   | 1/3 | 2/3 | 3/3 | 4/3 | 5/3 | 6/3 | ... | n/3 |
| 4   | 1/4 | 2/4 | 3/4 | 4/4 | 5/4 | 6/4 | ... | n/4 |
| 5   | 1/5 | 2/5 | 3/5 | 4/5 | 5/5 | 6/5 | ... | n/5 |
| 6   | 1/6 | 2/6 | 3/6 | 4/6 | 5/6 | 6/6 | ... | n/6 |
| ... | ... | ... | ... | ... | ... | ... | ... | ... |
| m   | 1/m | 2/m | 3/m | 4/m | 5/m | 6/m | ... | n/m |

Then we just snake through the numbers from the top left to get our list:

$$
\left\{  \frac{1}{1}, \frac{1}{2}, \frac{2}{1}, \frac{3}{1}, \frac{2}{2}, \frac{1}{3}, \frac{1}{4}, \frac{2}{3}, \frac{3}{2}, \frac{4}{1}, \dots \right\}
$$

which we can then map to the natural numbers, showing that the _rational numbers are countably infinite!_ Remember, this means that there are just as many rational numbers as there are natural numbers, integers, even numbers and odd numbers:

$$
|\mathbb{N}| = |\{ \text{even numbers} \}| = |\{ \text{odd numbers} \}| = |\mathbb{Z}| = |\mathbb{Q}|
$$

## Uncountable infinity

We're on such a hot streak, surely we can easily take on the next challenge, the real numbers ${}\mathbb{R}{}$! These are any decimal number, even those that can't be represented by rational numbers, like ${}\sqrt{ 2 }{}$, but that shouldn't be a problem for us. So let's start!

Uh... where do we start? Okay let's write 0. But then what? We can't write ${}0.1{}$ because there's ${}0.01{}$ before it. We can't write ${}0.01{}$ because there's ${}0.001{}$ before that, and so on. The next step up from 0 is ${}0.{}$ following by an infinite number of zeroes and then a 1 but, as we'll soon see, that's just equal to 0.

We can't count the real numbers, it's **uncountably infinite**. The complex numbers ${}\mathbb{C}{}$ are therefore also uncountably infinite, as they're a superset of the real numbers.

![Some different sets of numbers as a Venn diagram. Red means they're countably infinite, blue means they're uncountably infinite.](number-sets.svg)

## Repeating decimals

I mentioned earlier that the next step after 0 would be ${}0.{}$ followed by an infinite number of 0s and then a 1. Of course, there can't be a 1 at the end because there's an infinite number of 0s, so it's effectively

$$
0.000\ldots = 0.\overline{0}
$$

which we can pretty obviously say is equal to 0.

It gets a bit more confusing when you look at something like

$$
0.999\ldots = 0.\overline{9}
$$

This looks like its less than 1 by a very very very small amount. I claim this is equal to 1. My proof?

$$
\begin{aligned}
x & = 0.\overline{9} \\
10x & = 9.\overline{9} \\
10x-x & = 9.\overline{9}-0.\overline{9} \\
9x & = 9 \\
x & = 1
\end{aligned}
$$

That ${}9.\overline{9}-0.\overline{9} = 9{}$ step works because there are an infinite number of 9s which all perfectly cancel out.

$$
\begin{matrix}
& 9.999999\dots \\
- & 0.999999\dots \\
\hline
& 9.000000\dots
\end{matrix}
$$

Like the ${}0.\overline{0}{}$ case, the 9s never stop. The actual mathematical [series](#Sequences%20and%20series) here is:

$$
\sum_{i=1}^{N} \frac{9}{10^{i}} = \frac{9}{10}+\frac{9}{100}+\frac{9}{1000}+\cdots+\frac{9}{10^{N}}
$$

Which gets closer and closer to 1 as ${}N{}$ goes to infinity. This is also why there are no irrational numbers with repeating decimals, since you can always use this trick to simplify the decimal into a rational. For instance:

$$
\begin{aligned}
x & = 0.\overline{142857} \\
1000000x & = 142857.\overline{142857} \\
1000000x - x & = 142857.\overline{142857} - 0.\overline{142857} \\
999999x & = 142857 \\
x & = \frac{142857}{999999} \\
 & = \frac{1}{7} \\
\end{aligned}
$$

Another example:

$$
\begin{aligned}
x & = 0.\overline{1234} \\
10000x & = 1234.\overline{1234} \\
9999x & = 1234 \\
x & = \frac{1234}{9999}
\end{aligned}
$$

## Natural series

And for my final trick, I'd like to leave you with this:

$$
1 + 2 + 3 + \dots = -\frac{1}{12}
$$

Bizarre, I know. Before I explain this, I want to first explain what a _series_ is, and the difference from a _sequence_.

### Sequences and series

In short, a sequence is a list of numbers following some rule. For example, the Fibonacci sequence:

$$
0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, \dots
$$

which follows the rule:

$$
\begin{aligned}
F_{0} & = 0 \\
F_{1} & = 1 \\
F_{n} & = F_{n-1} + F_{n-2}
\end{aligned}
$$

which means that the nth Fibonacci number is the sum of the previous two Fibonacci numbers, with the sequence starting at 0 and 1. Similarly, the natural number sequence is:

$$
0, 1, 2, 3, 4, 5, 6, 7, 8, 9, \dots
$$

where:

$$
\begin{aligned}
N_{0} & = 0 \\
N_{n} & = N_{n-1} + 1
\end{aligned}
$$

On the other hand, a _series_ is the sum of a sequence. The natural number series is then:

$$
0 + 1 + 2 + 3 + 4 + 5 + 6 + 7 + 8 + 9 + \cdots
$$

or in more concise notation:

$$
\sum_{n=0}^{\infty} n
$$

### Convergence and divergence

Logically, you can see that the natural number series keeps getting larger and larger as we add more numbers. This is called a **divergent series**, because it never "collapses" toward a single value. Another divergent series is:

$$
\sum_{n=0}^{\infty} (-1)^{n}
$$

which flip-flops between 0 and 1. You can see this pretty easily if you write it out:

$$
\begin{aligned}
 1 &  + (-1) + 1 + (-1) + 1 + (-1) + 1 + (-1) + \dots \\
 & = 1 - 1 + 1 - 1 + 1 - 1 + 1 - 1 + \dots
\end{aligned}
$$

We can group these summations in two ways and get two different answers:

$$
\begin{aligned}
(1-1) + (1-1) + (1-1) + (1-1) + \dots & = 0 \\
1 + (-1 + 1) + (-1 + 1) + (-1 + 1) + \dots & = 1
\end{aligned}
$$

On the other hand, we have something like Zeno's dichotomy paradox. Let's say we have a 2 meter racetrack. To go across the length of the racetrack, you first have to go half the distance, so 1 m. Then you have to go half the remaining distance, so 0.5 m. Then half the remaining distance again, 0.25 m, and so on. You'll forever be covering half the remaining distance without ever reaching the end. What you effectively have is a sum that looks like:

$$
1 + \frac{1}{2} + \frac{1}{4} + \frac{1}{8} + \frac{1}{16} + \dots = \sum_{n=0}^{\infty} \frac{1}{2^{n}}
$$

On one hand, this is an infinite series, so it should sum to infinity since you're adding positive numbers forever, even if they're getting smaller and smaller. On the other hand, you know the length of that racetrack is 2, so the sum of the distances should be 2 m.

Your second intuition is correct, this is a series that converges to 2, an aptly named **convergent series**:

$$
\sum_{n=0}^{\infty} \frac{1}{2^{n}} = 2
$$

![The graph of ${}y=\sum_{n=0}^{x} \frac{1}{2^{n}}{}$. The red line gets closer and closer to ${}y=2{}$ but never reaches it.](zeno-dichotomy.svg)

What about something like this:

$$
\sum_{n=1}^{\infty} \frac{1}{n}
$$

That looks about the same, a sum of ever decreasing fractions. Would it ever converge? Surprisingly, no; this goes on to infinity, albeit very slowly; it's a divergent series.

Now that we know about convergent and divergent series, we can go back to our initial problem:

$$
1 + 2 + 3 + 4 + 5 + 6 + 7 + \dots = -\frac{1}{12}
$$

We saw earlier that this was a divergent series, so how are we converging it, and to a negative fraction no less? I'll give you a proof by [Srinivas Ramanujan](https://en.wikipedia.org/wiki/Srinivasa_Ramanujan). We start with:

$$
c = 1 + 2 + 3 + 4 + 5 + 6 + \cdots
$$

This looks pretty similar to the [power series expansion](https://en.wikipedia.org/wiki/Power_series):

$$
\frac{1}{(1+x)^{2}} = 1 - 2x + 3x^{2} - 4x^{3} + \cdots
$$

with ${}x = 1{}$. A power series expansion is basically a way to write a complicated expression in polynomial form (${}a + bx + cx^{2} + dx^{3} + \cdots{}$) so its easier to compute or at least approximate. That gives us:

$$
\begin{aligned}
\frac{1}{(1+1)^{2}} & = 1 - 2 + 3 - 4 + \cdots \\
 & = \frac{1}{2^{2}} = \frac{1}{4}
\end{aligned}
$$

To get ${}c{}$ to be in this form, we can just subtract 4 from the ${}+2{}$, 8 from the ${}+4{}$ and so on. So we just need to subtract ${}4c{}$ from ${}c{}$:

$$
\begin{aligned}
 & c  && = 1 && + 2 + 3 && + 4 + 5 && + 6  + \cdots \\
 & 4c && =   &&   4     && + 8     && + 12 + \cdots \\
 & c - 4c && = 1 && -2 + 3 && - 4 + 5 && - 6 + \cdots
\end{aligned}
$$

We now have:

$$
-3c = 1 - 2 + 3 - 4 + 5 - 6 + \cdots
$$

Using our earlier result for that power series expansion, we can then do:

$$
\begin{aligned}
-3c & = \frac{1}{4} \\
\implies c & = \frac{1}{4\times-3} = -\frac{1}{12}
\end{aligned}
$$

Therefore:

$$
\begin{aligned}
1 + 2 + 3 + 4 + 5 + 6 + \cdots = -\frac{1}{12}
\end{aligned}
$$

Wacky stuff, right?