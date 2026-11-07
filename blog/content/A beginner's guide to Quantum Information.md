---
date: 2026-10-06
slug: quantum-information
---

> [!note] Prerequisites
>
> This post assumes that you have knowledge of linear algebra, such as matrix and vector multiplications, eigenvectors and eigenvalues, etc. More advanced concepts like the Kronecker product will be explained briefly, but I won't go into too much detail about them. Knowledge of complex numbers and operations is also assumed.

Quantum computing is this hot new topic that's been around tech news in the last few years. There's claims flying around about how it's orders of magnitude faster than classical computers, and that it's going to break all of our encryption and cybersecurity. To be fair, a lot of that is true, to a certain extent. Quantum computers are much, much faster than classical computers **at certain tasks**, and there are in fact quantum algorithms that can break some **older** encryption schemes in a reasonable amount of time.

That said, quantum computing isn't a 1:1 replacement for classical computing; the way that quantum computers work is both very different and, at least to me, very fascinating. It's also not nearly as complicated as its often made to sound.

## The humble (qu)bit

Classical computers work on binary digits (a.k.a. bits), i.e. 0s and 1s. You've probably heard this a million times, but there's a key observation here that you might not have considered before. 0 and 1 are **discrete** values; if a bit isn't 0 it must be 1 and vice versa. We can call these the bit's "states": it can be in a state of 0 or a state of 1.

Qubits, on the other hand, aren't as straightforward. Bits are represented in hardware by low and high electrical signals, and qubits are represented by a two-level quantum mechanical system, like electron spin ("up" or "down"), or photon polarisation ("left-handed" or "right-handed"). However, due to the way that quantum mechanics works, these properties aren't inherently discrete.

An quantum mechanical system can exist in what's called a **superposition**, which is a separate, mixed state of its two discrete options. You'll often hear that it's "in both states at the same time" until you measure it, at which point the state collapses into one of its discrete options. But that's not fully accurate.

The way I understood it best is flipping a coin. While the coin is in the air flipping, it's not "heads" or "tails", it's in a third mixed state called "flipping". When the coin lands and you check it, its "flipping" state collapses into "heads" or "tails" with, assuming a fair coin, equal probability.

This isn't possible to model with a single bit, as a bit can only ever be 0 or 1, it can't ever be in that "flipping" state. However, a qubit can be, and we can write it as:

$$
\frac{1}{\sqrt{ 2 }}\ket{0} +\frac{1}{\sqrt{ 2 }}\ket{1}
$$

> [!note] Notation
>
> $\ket{0}$ is read as "ket 0", and it represents the part of the qubit's vector pointing in the $0$ direction. The counterpart to a "ket" is a "bra", written as $\bra{0}$. Together they make "bra-ket" notation, also known as _Dirac notation_. It's important to remember, the "0" and "1" here are **just labels**, they aren't real values. We could have just as well named them $\ket{h}$ and $\ket{t}$ and all of the math would work out exactly the same.
>
> Defining a bra is a bit complicated, but you can imagine it as the counterpart to a ket. The mathematical application of it is that, when you apply a bra to a ket, if the labels inside both are the same, then they cancel out to 1, otherwise they cancel out to 0:
>
> $$
> \begin{aligned}
> \braket{ 0 | 0 } = \braket{ 1 | 1 } = 1 \\
> \braket{ 0 | 1 } = \braket{ 1 | 0 } = 0
> \end{aligned}
> $$
>
> Here, $\braket{ 0 | 0 }$ is just a shorthand for $\bra{0}\ket{0}$, and you're effectively taking a dot product. We'll see this in closer detail when we look at [vector notation](#^vector-notation).

Here, $\ket{0}$ and $\ket{1}$ are the qubit's _basis states_. The definition of an eigenbasis is a bit complicated, but an easy way to imagine this is that a qubit exists on a unit circle, and these are the graph's $x$ and $y$ axes. The coefficients of the basis states then represent the actual $x$ and $y$ coordinates on that graph:

![The unit circle on the $\ket{0}$-$\ket{1}$ plane. Qubits lie somewhere on the blue line in this plane. The red line shows the vector for the $\frac{1}{\sqrt{2}} \ket{0} + \frac{1}{\sqrt{2}} \ket{1}$ qubit lying halfway between the $\ket{0}$ and $\ket{1}$ axes.](unit-circle.svg)

> [!note] Orthonormality
>
> The actual thing we're talking about here is called "orthonormality". This consists of two properties: orthogonality and normality. For an orthonormal eigenbasis:
>
> - **Orthogonality:** The basis vectors must be orthogonal, or at 90º to each other. This is what I meant when I said they were the $x$ and $y$ axes of a graph. The way this is actually defined is that their inner product $\braket{ a | b }=0$. This holds true for $\ket{0}$ and $\ket{1}$ since $\braket{ 0 | 1 }=\braket{ 1 | 0 }=0$.
> - **Normality:** The basis vectors must be normal. A vector is considered "normal" if its inner product with itself $\braket{ v | v }=1$. This must be true for any vector in the space, so any combination of the basis vectors. This is what I meant when I said that a qubit exists on the unit circle.
>
> So if two vectors $\ket{a}$ and $\ket{b}$ meet the condition:
>
> $$
> \braket{ a | b } = \begin{cases}
> 1 &  \text{if } a = b \\
> 0 &  \text{otherwise}
> \end{cases}
> $$
>
> then they are said to be orthonormal. While there are non-orthonormal eigenbases, we'll only be talking about orthonormal bases in this post.

In reality, the coefficients of the $\ket{0}$ and $\ket{1}$ are complex numbers, so even drawing a single qubit would actually require a 4-dimensional graph. I don't know how to make 4D graphs, so I'm just going to stick with this simplified example for now. Besides, it's not very useful to work with qubits on graphs since, as you can see, you run out of dimensions pretty quickly.

However, this graphical representation shows that qubits can be written as vectors using their coefficients:

$$
a_{0}\ket{0} +a_{1}\ket{1} = \begin{pmatrix}
a_{0} \\
a_{1}
\end{pmatrix}
$$

^vector-notation

> [!note] Vector definition of $\bra{\psi}$
>
> Now that we have our vector definitions for $\ket{\psi}$, we can better define $\bra{\psi}$. If $\ket{\psi}$ is a vertical vector, then $\bra{\psi}$ is a horizontal vector, such that:
>
> $$
> \begin{aligned}
> \bra{\psi}  & = a_{0}\bra{0} +a_{1}\bra{1} = \begin{pmatrix}
> a_{0} & a_{1}
> \end{pmatrix} \\
> \ket{\phi}  & =b_{0} \ket{0} +b_{1}\ket{1} = \begin{pmatrix}
> b_{0} \\
> b_{1}
> \end{pmatrix} \\
> \braket{ \psi | \phi }  & = \begin{pmatrix}
> a_{0} & a_{1}
> \end{pmatrix} \cdot \begin{pmatrix}
> b_{0} \\
> b_{1}
> \end{pmatrix} = a_{0}b_{0} + a_{1}b_{1}
> \end{aligned}
> $$
>
> We could derive the same result by doing the multiplication algebraically:
>
> $$
> \begin{aligned}
> \braket{ \psi | \phi }  & = (a_{0}\bra{0} +a_{1}\bra{1} )(b_{0}\ket{0} +b_{1}\ket{1} ) \\
>  & = a_{0}b_{0}\braket{ 0 | 0 } +a_{0}b_{1}\braket{ 0 | 1 } +a_{1}b_{0}\braket{ 1 | 0 } +a_{1}b_{1}\braket{ 1 | 1 }  \\
>  & = a_{0}b_{0}\times 1 + a_{0}b_{1}\times 0 +a_{1}b_{0}\times 0+a_{1}b_{1}\times 1 \\
>  & = a_{0}b_{0}+a_{1}b_{1}
> \end{aligned}
> $$
>
> I'm going to use both Dirac notation and vector notation interchangeably throughout this post since it's sometimes easier to do calculations with one or the other, so it's worth getting familiar with translating between both.

### Measuring a qubit

When we measure a qubit, we're collapsing it down from its superposition state down to one of its basis states. To do that, we're going to use the coefficient of each basis state, also known as the **amplitude**. The square of the amplitude represents the probability that, when measured, the qubit will collapse into that state:

$$
\begin{aligned}
\ket{\psi} = a_{0}\ket{0} +a_{1}\ket{1}  \\
\Pr(0) = |a_{0}|^{2} \\
\Pr(1) = |a_{1}|^{2}
\end{aligned}
$$

So for the $\frac{1}{\sqrt{ 2 }}\ket{0}+\frac{1}{\sqrt{ 2 }}\ket{1}$ case, we can say that $\ket{0}$ represents "heads" and $\ket{1}$ represents tails. The probability of each would be:

$$
\begin{aligned} \\
\Pr(0)=\left| \frac{1}{\sqrt{ 2 }} \right| ^{2} = \frac{1}{2} \\
\Pr(1)=\left| \frac{1}{\sqrt{ 2 }} \right| ^{2} = \frac{1}{2}
\end{aligned}
$$

thus representing our fair coin's 50/50 chance of heads or tails.

This brings with it another key observation: **the sum of the squares of the amplitudes must equal 1**. If we have a qubit $\ket{\psi}=a_{0}\ket{0}+a_{1}\ket{1}$, then the probability of measuring $0$ is $|a_{0}|^{2}$ and the probability of measuring $1$ is $|a_{1}|^{2}$. Since measuring must return _something_, the total probability must equal 100%, and therefore:

$$
\Pr(0) + \Pr(1) + \dots = |a_{0}|^{2}+|a_{1}|^{2} + \dots = 1
$$

> [!note] Derivation of $\braket{ \psi | \psi }=1$
>
> Using our vector definitions as well as our new sum of squares rule, we can also show how $\braket{ \psi | \psi }=1$:
>
> $$
> \begin{aligned}
> \ket{\psi} &  = \begin{pmatrix}
> a_{0} \\
> a_{1}
> \end{pmatrix} \\
> \braket{ \psi | \psi } & = \begin{pmatrix}
> a_{0} & a_{1}
> \end{pmatrix} \begin{pmatrix}
> a_{0} \\
> a_{1}
> \end{pmatrix} \\
>  & = a_{0}\times a_{0}+a_{1}\times a_{1} \\
>  & = |a_{0}|^{2} + |a_{1}|^{2} \\
>  & = 1
> \end{aligned}
> $$
>
> Note that we didn't specify any values of $a_0$ or $a_1$, so this applies to any quantum state, including basis states:
>
> $$
> \begin{aligned}
> \ket{0}  & = \begin{pmatrix}
> 1 \\
> 0
> \end{pmatrix} \implies \braket{ 0 | 0 } = 1^{2}+0^{2}=1 \\
> \ket{1}  & = \begin{pmatrix}
> 0 \\
> 1
> \end{pmatrix} \implies \braket{ 0 | 1 } = 0^{2}+1^{2}=1
> \end{aligned}
> $$

Now that we have our qubits, we want to be able to do something with them. To do that, we use operators.

## Operators

In classical computing, there are a number of operators, or **gates**, that can act on bits, which can be written out as truth tables. For example, the `NOT` operator, which inverts the bit:

| $A$ | $\neg A$ |
| --- | -------- |
| `0` | `1`      |
| `1` | `0`      |

Similarly, there are a number of quantum operators that can act on qubits. The quantum analogue to the classical `NOT` operator is the Pauli X operator:

$$
X = \begin{pmatrix}
0 & 1 \\
1 & 0
\end{pmatrix} = \ket{0} \bra{1} + \ket{1} \bra{0}
$$

> [!note] Vector derivation
>
> We can derive the $X$ operator using the vector forms of $\ket{\psi}$ and $\bra{\psi}$:
>
> $$
> \begin{aligned}
> X & = \ket{0} \bra{1} + \ket{1} \bra{0}  \\
>  & = \begin{pmatrix}
>  1 \\
>  0
>  \end{pmatrix} \begin{pmatrix}
>  0 & 1
>  \end{pmatrix} + \begin{pmatrix}
>  0 \\
>  1
>  \end{pmatrix} \begin{pmatrix}
>  1 & 0
>  \end{pmatrix} \\
>   & = \begin{pmatrix}
>   0 & 1 \\
>   0 & 0
>   \end{pmatrix} + \begin{pmatrix}
>   0 & 0 \\
>   1 & 0
>   \end{pmatrix} \\
>    & = \begin{pmatrix}
>    0 & 1 \\
>    1 & 0
>    \end{pmatrix}
> \end{aligned}
> $$

The way to apply an operator is to take the dot product with the qubit you want to apply it to:

$$
\begin{aligned}
X \ket{0}  & = (\ket{0} \bra{1} + \ket{1} \bra{0}  )\ket{0} \\
 & = \ket{0} \braket{ 1 | 0 } +\ket{1} \braket{ 0 | 0 }  \\
 & = \ket{1}
\end{aligned}
$$

or in vector notation:

$$
\begin{aligned}
\begin{pmatrix}
0 & 1 \\
1 & 0
\end{pmatrix} \begin{pmatrix}
1 \\
0
\end{pmatrix} & = \begin{pmatrix}
0\times 1+1\times 0 \\
1\times 1+0\times 0
\end{pmatrix} \\
&= \begin{pmatrix}
0 \\
1
\end{pmatrix} = \ket{1}
\end{aligned}
$$

Below is a brief list of common single-qubit quantum operators:

| Name     | Symbol | Matrix                                                            | Dirac                                                                               |
| -------- | ------ | ----------------------------------------------------------------- | ----------------------------------------------------------------------------------- |
| Hadamard | $H$    | $\frac{1}{\sqrt{ 2 }}\begin{pmatrix}1 & 1 \\ 1 & -1\end{pmatrix}$ | $\frac{1}{\sqrt{ 2 }}(\ket{0}\bra{0}+\ket{0}\bra{1}+\ket{1}\bra{0}-\ket{1}\bra{1})$ |
| Pauli X  | $X$    | $\begin{pmatrix}0 & 1 \\ 1 & 0\end{pmatrix}$                      | $\ket{0}\bra{1}+\ket{1}\bra{0}$                                                     |
| Pauli Y  | $Y$    | $\begin{pmatrix}0 & -i \\ i & 0\end{pmatrix}$                     | $-i\ket{0}\bra{1}+i\ket{1}\bra{0}$                                                  |
| Pauli Z  | $Z$    | $\begin{pmatrix}1 & 0 \\ 0 & -1\end{pmatrix}$                     | $\ket{0}\bra{0}-\ket{1}\bra{1}$                                                     |
| Identity | $I$    | $\begin{pmatrix}1 & 0 \\ 0 & 1\end{pmatrix}$                      | $\ket{0}\bra{0}+\ket{1}\bra{1}$                                                     |

^common-operators

## Multiple qubits

Just as adding more classical bits makes it easier to perform larger calculations, adding more qubits makes a quantum computer more powerful. But now we have to worry about how to handle all of these qubits! Turns out, this isn't that difficult (at least mathematically), we just put them together!

We can combine multiple qubits by taking their Kronecker product:

$$
\ket{0} \otimes \ket{0} \otimes \dots \otimes \ket{0}
$$

However, that's tedious to write, so there are shorter forms of this:

$$
\ket{0} \ket{0} \dots \ket{0} = \ket{00\dots 0}
$$

For example, a 2-qubit state can be written as:

$$
\ket{0} \otimes \ket{0} = \ket{0} \ket{0} = \ket{00}
$$

> [!note] Kronecker product
>
> The Kronecker product, also known as the tensor product, is denoted by $\otimes$ and is an operation on a vector or matrix that increases its size. The way it works is pretty simple, you just multiply the right hand side by each element of the left hand side:
>
> $$
> \begin{aligned}
> \ket{\phi} & = \begin{pmatrix}
> a_{0} \\
> a_{1}
> \end{pmatrix}  \\
> \ket{\psi}  & = \begin{pmatrix}
> b_{0} \\
> b_{1}
> \end{pmatrix} \\
> \ket{\phi} \otimes \ket{\psi}  & = \begin{pmatrix}
> a_{0} \cdot \ket{\psi}  \\
> a_{1} \cdot \ket{\psi}
> \end{pmatrix} \\
>  & = \begin{pmatrix}
>  a_{0} \cdot \begin{pmatrix}
>  b_{0} \\
>  b_{1}
>  \end{pmatrix} \\
>  a_{1} \cdot \begin{pmatrix}
>  b_{0} \\
>  b_{1}
>  \end{pmatrix}
>  \end{pmatrix} \\
>   & = \begin{pmatrix}
>   a_{0}\times b_{0} \\
>   a_{0}\times b_{1} \\
>   a_{1}\times b_{0} \\
>   a_{1}\times b_{1}
>   \end{pmatrix}
> \end{aligned}
> $$
>
> For instance, let's take the tensor product $\ket{0}\otimes \ket{0}$:
>
> $$
> \begin{aligned}
> \ket{0}  & = \begin{pmatrix}
> 1 \\
> 0
> \end{pmatrix} \\
> \ket{0} \otimes \ket{0}  & = \begin{pmatrix}
> 1 \\
> 0
> \end{pmatrix} \otimes \begin{pmatrix}
> 1 \\
> 0
> \end{pmatrix} \\
>  & = \begin{pmatrix}
>  1 \cdot \begin{pmatrix}
>  1 \\
>  0
>  \end{pmatrix} \\
>  0 \cdot \begin{pmatrix}
>  1 \\
>  0
>  \end{pmatrix}
>  \end{pmatrix} \\
>   & = \begin{pmatrix}
>   1\times 1 \\
>   1\times 0 \\
>   0\times 1 \\
>   0\times 0
>   \end{pmatrix} \\
>    & = \begin{pmatrix}
>    1 \\
>    0 \\
>    0 \\
>    0
>    \end{pmatrix}
> \end{aligned}
> $$
>
> If we have two qubits and we take their Kronecker product, we can write the output in a form known as **product form**:
>
> $$
> \begin{aligned}
> \ket{\alpha}  & = a_{0}\ket{0} +a_{1}\ket{1}  \\
> \ket{\beta}  & = b_{0}\ket{0} +b_{1}\ket{1}  \\
> \ket{\alpha} \ket{\beta}  & = a_{0}b_{0}\ket{00} +a_{0}b_{1}\ket{01} +a_{1}b_{0}\ket{10} +a_{1}b_{1}\ket{11}  \\
>  & = \begin{pmatrix}
>  a_{0}b_{0} \\
>  a_{0}b_{1} \\
>  a_{1}b_{0} \\
>  a_{1}b_{1}
>  \end{pmatrix}
> \end{aligned}
> $$

^kronecker-product

As before, any multiple-qubit state can be written in vector notation as well. For example, a two qubit state:

$$
\begin{aligned}
\ket{\psi}  & = a_{00}\ket{00} +a_{01}\ket{01} +a_{10}\ket{10} +a_{11}\ket{11}  \\
 & = \begin{pmatrix}
 a_{00} \\
 a_{01} \\
 a_{10} \\
 a_{11}
 \end{pmatrix}
\end{aligned}
$$

## Entanglement

Entanglement is a property that allows qubits to combine together into a single combined state. Before we explore that, we need to understand what defines entanglement.

To start, let's try writing this qubit in product form:

$$
\begin{aligned}
\ket{\Phi}  = & \frac{\ket{00} +\ket{11} }{\sqrt{ 2 }} \\
 & = a_{0}b_{0}\ket{00} +a_{0}b_{1}\ket{01} +a_{1}b_{0}\ket{10} +a_{1}b_{1}\ket{11}
\end{aligned}
$$

Here, $a_{0}b_{0}=a_{1}b_{1}=\frac{1}{\sqrt{ 2 }}$ and $a_{0}b_{1}=a_{1}b_{0}=0$. That in turn implies that either $a_{0}$ or $b_{1}$ must be zero, and either $a_{1}$ or $b_{0}$ must be zero.

- If $a_{0}=0$, then $a_{0}b_{0}=0$.
- If $a_{1}=0$, then $a_{1}b_{1}=0$.
- If $b_{0}=0$, then $a_{0}b_{0}=0$.
- If $b_{1}=0$, then $a_{1}b_{1}=0$.

Uh oh, we've hit a roadblock! No matter what values for $a_{0}$, $a_{1}$, $b_{0}$ and $b_{1}$ we choose, we will never get this state. Since we cannot separate the state into its individual qubits, we say that this state is **entangled**. In fact, this specific state is known as the "maximally entangled state".

Let's look at a non-entangled state for comparison:

$$
\begin{aligned}
\ket{\psi} = & \frac{\ket{00} +\ket{10} }{\sqrt{ 2 }} \\
 = & a_{0}b_{0}\ket{00} +a_{0}b_{1}\ket{01} +a_{1}b_{0}\ket{10} +a_{1}b_{1}\ket{11}
\end{aligned}
$$

Here, $a_{0}b_{0}=a_{1}b_{0}=\frac{1}{\sqrt{ 2 }}$ and $a_{0}b_{1}=a_{1}b_{1}=0$, meaning that either $a_{0}$ or $b_{1}$ must be zero, and either $a_{1}$ or $b_{1}$ must be zero. From that, we can see quite easily that setting $b_{1}=0$ solves our problem.

$$
\begin{aligned}
a_{0}b_{1} & =a_{1}b_{1}=0 \\
\ket{\psi}  & = a_{0}b_{0}\ket{00} +0 \ket{01} + a_{1}b_{0}\ket{10} + 0\ket{11}  \\
 & = a_{0}b_{0}\ket{00} +a_{1}b_{0}\ket{10}
\end{aligned}
$$

Separating out the original qubit:

$$
\begin{aligned}
\ket{\psi}  & = \left( \frac{\ket{0} +\ket{1} }{\sqrt{ 2 }} \right)\ket{0}  \\
\implies \ket{a}  & = \frac{\ket{0} +\ket{1} }{\sqrt{ 2 }} \\
\ket{b}  & = \ket{0} \\
\ket{a} \ket{b}  & = \frac{\ket{00} +\ket{10} }{\sqrt{ 2 }} = \ket{\psi}
\end{aligned}
$$

Entanglement means that the qubits are linked together into **one single system**. Affecting one affects the other instantly; you can't change them individually. Physically, this is a bit complicated, but you can imagine a long invisible rod that's connecting the two particles, where moving one end of the rod moves the other end instantly.

Where this analogy falls apart is that it assumes a perfectly rigid object, which doesn't exist. Every material on Earth is made up of molecules that are held together by electromagnetic forces, and the speed at which the movement of one molecule affects the next is basically just the speed of sound in that material, since sound is simply a wave of pushing molecules in its direction of travel. However, making changes (applying operators) to entangled qubits is genuinely instant.

We'll explore some of the consequences of this later. For now, since we have a good understanding of how multiple-qubit systems work, we can look at how to apply operators onto them.

## Multiple qubit operators

Just as you could apply operators to a single qubit, you can apply them to multiple qubits at the same time. We can start by applying a single-qubit gate to a two-qubit state:

$$
\begin{aligned}
X\ket{10}  & = \begin{pmatrix}
0 & 1 \\
1 & 0
\end{pmatrix} \begin{pmatrix}
0 \\
0 \\
1 \\
0
\end{pmatrix} \\
 & = (\ket{0} \bra{1} +\ket{1} \bra{0} )\ket{10}  \\
 & = \ket{0} \braket{ 1 | 10 } +\ket{1} \braket{ 0 | 10 }
\end{aligned}
$$

Uh oh, we seem to have hit another roadblock! Since this is a single-qubit gate, it can only be applied to a single qubit. In order to apply an operator to a two-qubit state, we need to make it a two-qubit gate. We can do this by using the [tensor product](#^kronecker-product) again:

$$
(X \otimes I)\ket{10} =\ket{00}
$$

The way this works is that, going from left to right, the first gate applies to the first qubit, the second gate applies to the second qubit, and so on.

> [!note] Derivation
>
> We can again derive this using both vector and Dirac notations.
>
> Vector notation:
>
> $$
> \begin{aligned}
> X & = \begin{pmatrix}
> 0 & 1 \\
> 1 & 0
> \end{pmatrix} \\
> I & = \begin{pmatrix}
> 1 & 0 \\
> 0 & 1
> \end{pmatrix} \\
> X \otimes I  & = \begin{pmatrix}
> 0 \cdot I & 1 \cdot I \\
> 1 \cdot I & 0 \cdot I
> \end{pmatrix} \\
>  & = \begin{pmatrix}
>  0 & 0 & 1 & 0 \\
>  0 & 0 & 0 & 1 \\
>  1 & 0 & 0 & 0 \\
>  0 & 1 & 0 & 0
>  \end{pmatrix} \\
>  \ket{10}  & = \begin{pmatrix}
>  0 \\
>  0 \\
>  1 \\
>  0
>  \end{pmatrix} \\
>   \\
>  (X \otimes I)\ket{10} & = \begin{pmatrix}
>  0 & 0 & 1 & 0 \\
>  0 & 0 & 0 & 1 \\
>  1 & 0 & 0 & 0 \\
>  0 & 1 & 0 & 0
>  \end{pmatrix} \begin{pmatrix}
>  0 \\
>  0 \\
>  1 \\
>  0
>  \end{pmatrix}  \\
>   & = \begin{pmatrix}
>   1 \\
>   0 \\
>   0 \\
>   0
>   \end{pmatrix} \\
>    & = \ket{00}
> \end{aligned}
> $$
>
> Dirac notation:
>
> $$
> \begin{aligned}
> X \otimes I  & = &  & (\ket{0} \bra{1} +\ket{1} \bra{0} )\otimes (\ket{0} \bra{0} +\ket{1} \bra{1} ) \\
>  & =  &  & \ket{00} \bra{10} +\ket{01} \bra{11} +\ket{10} \bra{00} +\ket{11} \bra{01}  \\
>  \\
> (X \otimes I)\ket{10}  & = &  & (\ket{00} \bra{10} +\ket{01} \bra{11} +\ket{10} \bra{00} +\ket{11} \bra{01} )\ket{10}  \\
>  & = &  & \ket{00} \braket{ 10 | 10 } +\ket{01} \braket{ 11 | 10 }  \\
>  &  &  & +\ket{10} \braket{ 00 | 10 } +\ket{11} \braket{ 01 | 10 }  \\
>  & = &  & \ket{00} \times 1 + \ket{01} \times 0+\ket{10} \times 0 +\ket{11} \times 0  \\
>  & = &  & \ket{00}
> \end{aligned}
> $$
>
> When you're doing the tensor product $\ket{a}\bra{b} \otimes \ket{p}\bra{q}$, you can pull the $\ket{a}$ and $\bra{b}$ through to their respective ket and bra on the other side:
>
> $$
> \begin{aligned}
> \ket{a} \bra{b} \otimes \ket{p} \bra{q}  & = (\ket{a} \otimes \ket{p} )(\bra{b} \otimes \bra{q} ) \\
>  & = \ket{ap} \bra{bq}
> \end{aligned}
> $$

We can apply individual operators on individual qubits, but that doesn't get us very far. For the true power of quantum computing, we need to be able to entangle qubits. For that, we need a truly multi-qubit operator. One common example is the controlled `NOT`, or the $\text{CNOT}$ operator. Since we know that the $X$ gate is the quantum analogue to the `NOT` gate, this is also sometimes called the $\text{CX}$ operator.

$$
\begin{aligned}
\text{CX }  & = \ket{00} \bra{00} +\ket{01} \bra{01} +\ket{10} \bra{11} +\ket{11} \bra{10}  \\
 & = \begin{pmatrix}
 1 & 0 & 0 & 0 \\
 0 & 1 & 0 & 0 \\
 0 & 0 & 0 & 1 \\
 0 & 0 & 1 & 0
 \end{pmatrix}
\end{aligned}
$$

The way this works is, when applied to a two-qubit state, it'll apply a `NOT` onto the second qubit if the first qubit is a $\ket{1}$.

$$
\begin{aligned}
\text{CX } \ket{00} = \ket{00}  \\
\text{CX } \ket{01} = \ket{01}  \\
\text{CX } \ket{10} = \ket{11} \\
\text{CX } \ket{11} = \ket{10}
\end{aligned}
$$

As you can see, when the first qubit is a $\ket{1}$, such as in the $\ket{10}$ and $\ket{11}$ cases, the second qubit gets toggled ($\ket{10}\to \ket{11}$ and $\ket{11}\to \ket{10}$, respectively).

Gates like these are the **only way to get entangled qubits**, you cannot get them from combining single-qubit gates alone. To see how, let's look at the maximally entangled state again:

$$
\ket{\Phi} = \frac{\ket{00} +\ket{11} }{\sqrt{ 2 }}
$$

How would we go about making this state? Well let's start from a very simple state: the $\ket{00}$. If we have a look at the [single-qubit operators table](#^common-operators) from earlier, we can see that the Hadamard looks like it'll get us about halfway there. So let's apply a $H \otimes I$ to this state.

$$
\begin{aligned}
H \otimes I \ket{00}  & = \frac{\ket{0} +\ket{1} }{\sqrt{ 2 }}\ket{0}  \\
 & = \frac{\ket{00} +\ket{10} }{\sqrt{ 2 }}
\end{aligned}
$$

Ooh, so close. We just need a way to turn that $\ket{10}$ into a $\ket{11}$. Let's try applying an $X$ gate on the second qubit, so an $I \otimes X$:

$$
I \otimes X \frac{\ket{00} +\ket{10} }{\sqrt{ 2 }}= \frac{\ket{01} +\ket{11} }{\sqrt{ 2 }}
$$

Well that solved our $\ket{11}$ problem, but it left us with a $\ket{01}$ instead. We need something that'll apply an $X$, but only when that first qubit is a $\ket{1}$. So let's use our handy dandy $\text{CNOT}$!

$$
\text{CNOT } \frac{\ket{00} +\ket{10} }{\sqrt{ 2 }}=\frac{\ket{00} +\ket{11} }{\sqrt{ 2 }}
$$

We got it! As you can see, there's no single qubit gate that could've done that, so we required a multiple-qubit gate like the $\text{CNOT}$. Any combination of single-qubit gates would be of the form $U \otimes V$, which cannot entangle qubits since they act separately on individual qubits. Whereas multiple-qubit gates act on the entire multiple-qubit state at once to entangle it.

And that's it! That's all of the basic math of quantum computation. Everything we do from now on will be based on various applications of these basic rules. Pretty much all of quantum computation is based on these fairly simple (though not always easy) matrix multiplications.

> [!note] Universal gate set
>
> A fairly well-known fact about classical computing is that [all bit operations can be implemented with just the `NAND` gate](https://en.wikipedia.org/wiki/NAND_logic). This is pretty easy to prove, you could probably do it yourself if you know your logic gates, [there's even a whole game about it](https://nandgame.com)!
>
> Similarly, there exists a minimal set of quantum gates, known as the [universal gate set](https://en.wikipedia.org/wiki/Quantum_logic_gate#Universal_quantum_gates), that can be used to make every other operator. The smallest one found so far is the [Toffoli gate](https://en.wikipedia.org/wiki/Toffoli_gate) and the Hadamard gate. However, the [proof for this](https://arxiv.org/abs/quant-ph/0301040) isn't as straightforward as that for the `NAND` gate.

## Measurement

We talked briefly about [measuring a qubit earlier](#measuring-a-qubit), but let's dive a little deeper into what that actually means.

### Spectral decomposition

Before we talk about measurement, we have to talk about spectral decomposition. This is basically breaking down an $n$-by-$n$ operator into the form:

$$
U = \sum_{i=0}^{n-1} \lambda_{i} \ket{v_{i}} \bra{v_{i}}
$$

where $\lambda_{i}$ are known as the **eigenvalues**. These eigenvalues are the things that we can observe, not the actual qubit values $\ket{0}$ and $\ket{1}$ themselves, since remember, **those are just labels**. Let's try to get the spectral decomposition of the Pauli $X$ operator. Since $X$ is a 1-qubit operator, $n=2$. For 2-qubit operators, $n=4$, for 3 qubits, $n=8$, and so on.

$$
\begin{aligned}
X & = \sum_{i=0}^{1} \lambda_{i}\ket{v_{i}} \bra{v_{i}}  \\
 & = \lambda_{0} \ket{v_{0}} \bra{v_{0}} +\lambda_{1}\ket{v_{1}} \bra{v_{1}}
\end{aligned}
$$

We can't do this in the $\ket{0}$ and $\ket{1}$ eigenbasis because $\ket{v_{i}}$ and $\bra{v_{i}}$ wouldn't have the same label, while $\lambda_{0}$ and $\lambda_{1}$ would both be $+1$:

$$
X = \ket{0} \bra{1} +\ket{1} \bra{0}
$$

Looks like we'll need to use a different one. Let's look at the $\ket{+}$ and $\ket{-}$ eigenbasis, where:

$$
\begin{aligned}
\ket{+}  & = \frac{\ket{0} +\ket{1} }{\sqrt{ 2 }} \\
\ket{-}  & = \frac{\ket{0} -\ket{1} }{\sqrt{ 2 }}
\end{aligned}
$$

> [!note] Orthonormality
>
> We can prove that this eigenbasis is orthonormal.
>
> $$
> \begin{aligned}
> \braket{ + | - }  & = \frac{\bra{0} +\bra{1} }{\sqrt{ 2 }} \frac{\ket{0} -\ket{1} }{\sqrt{ 2 }} \\
>  & = \frac{\braket{ 0 | 0 } -\braket{ 0 | 1 } +\braket{ 1 | 0 } -\braket{ 1 | 1 } }{2} \\
>  & = \frac{1-0+0-1}{2} \\
>  & = 0 \\
> \braket{ + | + }  & = \frac{\bra{0} +\bra{1} }{\sqrt{ 2 }} \frac{\ket{0} +\ket{1} }{\sqrt{ 2 }} \\
>  & = \frac{\braket{ 0 | 0 } +\braket{ 0 | 1 } +\braket{ 1 | 0 } + \braket{ 1 | 1 } }{2} \\
>  & = \frac{1+0+0+1}{2} \\
>  & = 1
> \end{aligned}
> $$
>
> Proving this for $\braket{ - | + }$ and $\braket{ - | - }$ is left as an exercise to the reader ;)

Relabelling $0$ to $+$ and $1$ to $-$, we can write $X$ as:

$$
X = \lambda_{+} \ket{v_{+}} \bra{v_{+}} + \lambda_{-} \ket{v_{-}} \bra{v_{-}}
$$

Let's try using $\ket{v_{+}} = \ket{+}$ and $\ket{v_{-}}= \ket{-}$:

$$
\begin{aligned}
X & = &  & \lambda_{+}\ket{+} \bra{+} + \lambda_{-}\ket{-}\bra{-}  \\
 & = &  & \lambda_{+} \frac{\ket{0} \bra{0} +\ket{0} \bra{1} +\ket{1} \bra{0} +\ket{1} \bra{1} }{2} \\
 &  &  & + \lambda_{-} \frac{\ket{0} \bra{0} -\ket{0} \bra{1} -\ket{1} \bra{0} +\ket{1} \bra{1} }{2}
\end{aligned}
$$

Setting $\lambda_{+} = +1$ and $\lambda_{-}=-1$, we get:

$$
\begin{aligned}
X & = &  & \frac{\ket{0} \bra{0} +\ket{0} \bra{1} +\ket{1} \bra{0} +\ket{1} \bra{1} }{2} \\
 &  &  & - \frac{\ket{0} \bra{0} -\ket{0} \bra{1} -\ket{1} \bra{0} +\ket{1} \bra{1} }{2} \\
 & = &  & \frac{2 \ket{0} \bra{1} +2 \ket{1} \bra{0} }{2} \\
 & = &  & \ket{0} \bra{1} +\ket{1} \bra{0}
\end{aligned}
$$

which was our original definition for $X$.

We now have our two eigenvalues $\lambda_{+} = +1$ and $\lambda_{-}=-1$ that we can use when measuring a qubit with $X$. The way to get the probability of these eigenvalues is by using something called the **projector**. That's just the $\ket{v_{i}}\bra{v_{i}}$ state we saw in the spectral decomposition. So the projectors for $\lambda_{+}$ and $\lambda_{-}$ are:

$$
\begin{aligned}
\lambda_{+} \mapsto P_{+} = \ket{+} \bra{+}  \\
\lambda_{-} \mapsto P_{-} = \ket{-} \bra{-}
\end{aligned}
$$

### Measurement

Measurement is just the application of an operator in a given basis. For example, we can take the Pauli $X$ operator again. We use the spectral decomposition:

$$
\begin{aligned}
X & = \lambda_{+}P_{+} + \lambda_{-}P_{-} \\
 & = \ket{+} \bra{+} -\ket{-} \bra{-}  \\
\lambda_{+} & = +1 \\
P_{+} & = \ket{+} \bra{+}  \\
\lambda_{-} & = -1 \\
P_{-} & = \ket{-} \bra{-}
\end{aligned}
$$

The probability of the measurement outcome $\lambda_{+} = +1$ is then given by:

$$
\braket{ \psi | P_{+} | \psi }
$$

where $\ket{\psi}$ is the state you're trying to measure. So for the $\ket{0}$ state:

$$
\begin{aligned}
\braket{ 0 | P_{+} | 0 }  & = \braket{ 0 | [\ket{+} \bra{+} ] |0 } \\
 & = \braket{ 0 | + } \braket{ + | 0 }  \\
 & = \bra{0} \frac{\ket{0} + \ket{1} }{\sqrt{ 2 }} \frac{\bra{0} + \bra{1} }{\sqrt{ 2 }} \ket{0}  \\
 & = \frac{\braket{ 0 | 0 } +\braket{ 0 | 1 } }{\sqrt{ 2 }} \frac{\braket{ 0 | 0 } +\braket{ 1 | 0 } }{\sqrt{ 2 }} \\
 & = \frac{1}{\sqrt{ 2 }} \times \frac{1}{\sqrt{ 2 }} \\
 & = \frac{1}{2}
\end{aligned}
$$

So when measuring with $X$, there is a 50% chance of seeing a $+1$ when you have a $\ket{0}$. Conversely, the probability of getting a $-1$ outcome is also 50%:

$$
\begin{aligned}
\braket{ 0 | P_{-} | 0 }  & = \braket{ 0 | [\ket{-} \bra{-} ] | 0 }  \\
 & = \braket{ 0 | - } \braket{ - | 0 }  \\
 & = \bra{0} \frac{\ket{0} -\ket{1} }{\sqrt{ 2 }} \frac{\bra{0} -\bra{1} }{\sqrt{ 2 }}\ket{0}  \\
 & = \frac{\braket{ 0 | 0 } - \braket{ 0 | 1 } }{\sqrt{ 2 }} \frac{\braket{ 0 | 0 } -\braket{ 1 | 0 } }{\sqrt{ 2 }} \\
 & = \frac{1}{\sqrt{ 2 }} \times \frac{1}{\sqrt{ 2 }} \\
 & = \frac{1}{2}
\end{aligned}
$$

You'd get the same values when trying to measure the $\ket{1}$ state with $X$.

## Applications

By playing around with some quantum computing applications, we can get a better sense of what it's good for and what its limitations are. The math in this section gets a lot more involved than what we've been doing so far, so keep that in mind and make sure you're fairly comfortable with everything before this point.

### Teleportation

Let's say we have our two classic characters, Alice and Bob. Alice wants to send a message to Bob, but Bob, being about a light year away at Proxima Centauri, is _really_ far away, so I don't think the post will work. She thinks about using email, but email is, at best, limited by the speed of light, meaning it'll still take a year for the email to reach Bob. Suddenly, she remembers that she and Bob share a maximally entangled state:

$$
\frac{1}{\sqrt{ 2 }}[\ket{0} _{A_{1}}\ket{0} _{B}+\ket{1} _{A_{1}}\ket{1}_{B} ]
$$

where the $A_1$ subscript is Alice's qubit, and $B$ is Bob's qubit. Knowing that quantum entanglement works instantly, could she use this to send her message?

Let's say Alice's message is the unknown state $\ket{\psi}= a\ket{0}_{A} + b\ket{1}_{A}$. The complete state is then

$$
[a\ket{0} _{A}+b\ket{1} _{A}] \frac{1}{\sqrt{ 2 }} [\ket{0} _{A_{1}}\ket{0} _{B}+\ket{1} _{A_{1}}\ket{1} _{B}]
$$

which can be expanded out to

$$
\begin{aligned}
 & \frac{1}{2\sqrt{ 2 }} [\ket{0} _{A}\ket{0} _{A_{1}} + \ket{1} _{A}\ket{1} _{A_{1}}] [a \ket{0} _{B}+b\ket{1} _{B} ] \\
 & + \frac{1}{2\sqrt{ 2 }} [\ket{0} _{A}\ket{0} _{A_{1}} - \ket{1} _{A}\ket{1} _{A_{1}}] [a\ket{0} _{B}-b\ket{1} _{B}] \\
 & + \frac{1}{2\sqrt{ 2 }} [\ket{0} _{A}\ket{1}_{A_{1}}+\ket{1} _{A}\ket{0} _{A_{1}} ] [b\ket{0} _{B}+a \ket{1} _{B}] \\
 & + \frac{1}{2\sqrt{ 2 }} [\ket{0} _{A}\ket{1} _{A_{1}} - \ket{1} _{A}\ket{0} _{A_{1}}] [-b \ket{0} _{B}+a\ket{1} _{B}]
\end{aligned}
$$

Alice then measures her two-qubit state, the one with the $\ket{u}_{A}\ket{v}_{A_{1}}$, with an operator such that it has 4 different eigenvalues $\lambda_{1}$, $\lambda_{2}$, $\lambda_{3}$ and $\lambda_{4}$ corresponding to each of the states.

$$
\begin{aligned}
\frac{1}{\sqrt{ 2 }} [\ket{0} _{A}\ket{0} _{A_{1}}+\ket{1} _{A}\ket{1} _{A_{1}}] = & \ket{\Phi_{I}}  \\
\frac{1}{\sqrt{ 2 }} [\ket{0} _{A}\ket{0} _{A_{1}}-\ket{1} _{A}\ket{1} _{A_{1}}] = & \ket{\Phi_{Z}}  \\
\frac{1}{\sqrt{ 2 }} [\ket{0} _{A}\ket{1} _{A_{1}}+\ket{1} _{A}\ket{0} _{A_{1}}] = & \ket{\Phi_{X}}  \\
\frac{1}{\sqrt{ 2 }} [\ket{0} _{A}\ket{1} _{A_{1}}-\ket{1}_{A} \ket{0} _{A_{1}}] = & -\ket{\Phi_{Y}}
\end{aligned}
$$

You'll notice these look pretty similar to the $I$, $Z$, $X$ and $Y$ gates we saw earlier.

All of this probably sounds a bit confusing, but notice what happened to Bob's state above. All of those look kind of like that $\ket{\psi}$ state we started out with. In fact, based on what eigenvalue Alice finds from her measurement, she knows which state Bob got:

$$
\begin{aligned}
\lambda_{1} & \mapsto [a\ket{0} _{B}+b\ket{1} _{B}] \\
\lambda_{2} & \mapsto [a\ket{0} _{B}-b\ket{1} _{B}] \\
\lambda_{3} & \mapsto [b\ket{0} _{B}+a\ket{1} _{B}] \\
\lambda_{4} & \mapsto [-b\ket{0} _{B}+a\ket{1} _{B}]
\end{aligned}
$$

since it's just the corresponding state from her $\ket{\Phi}$ state above. So if she got $\lambda_{1}$ for instance, she got the state that has $[\ket{0}_{A}\ket{0}_{A_{1}}+\ket{1}_{A}\ket{1}_{A_{1}}]$ since that's the vector that corresponds to that eigenvalue. Since her and Bob's qubits are entangled, Bob therefore must have gotten the other half of that state, $[a\ket{0}_{B}+b\ket{1}_{B}]$.

However, Bob doesn't know this yet. As far as he knows, he could still have any of the 4 possibilities:

$$
\begin{aligned}
\frac{1}{2} [a\ket{0} _{B}+b\ket{1} _{B}] \\
\frac{1}{2} [a\ket{0} _{B}-b\ket{1} _{B}] \\
\frac{1}{2} [b\ket{0} _{B}+a\ket{1} _{B}] \\
\frac{1}{2} [-b\ket{0} _{B}+a\ket{1} _{B}] \\
 \\
\Pr = \left| \frac{1}{2} \right| ^{2} = \frac{1}{4}
\end{aligned}
$$

with equal probability $\Pr = \left| \frac{1}{2} \right|^{2} = \frac{1}{4}$. However, based on the eigenvalue that Alice measures, she can send him a 2 bit message to tell him which operator to measure with.

$$
\begin{aligned}
\lambda_{1} & \mapsto 00 &  & \to \text{measure } I \text{ (do nothing)} \\
\lambda_{2} & \mapsto 01 &  & \to \text{measure } Z \\
\lambda_{3} & \mapsto 10 &  & \to \text{measure } X \\
\lambda_{4} & \mapsto 11 &  & \to \text{measure } Y
\end{aligned}
$$

Following these instructions, Bob can get $\ket{\psi}$ back in all cases:

$$
\begin{aligned}
I [a \ket{0} _{B}+b\ket{1} _{B}] & = [a\ket{0} _{B}+b\ket{1} _{B}] \\
Z [a \ket{0} _{B}-b\ket{1} _{B}] & = [a\ket{0} _{B}+b\ket{1} _{B}] \\
X [b \ket{0} _{B}+a\ket{1} _{B}] & = [b \ket{1} _{B}+a\ket{0} _{B}] = [a \ket{0} _{B}+b\ket{1} _{B}] \\
Y [-b \ket{0} _{B}+a\ket{1} _{B}] & = [b\ket{1} _{B}+a\ket{0} _{B}] = [a\ket{0} _{B}+b\ket{1} _{B}]
\end{aligned}
$$

There's a factor of $i$ in the last case but we can just ignore it.

Now you may be thinking, how exactly is Alice meant to send the 2 bit message to Bob? I thought we were doing all this to send a message instantly and avoid that pesky speed of light limit. Well the truth is, you can't. Even though Alice knew which state Bob had, since Bob never got that knowledge, there was **no information transfer faster than the speed of light**. I'm sure Einstein is very pleased with this.

### Super-dense coding

Although we couldn't send messages faster than light, we can make the message itself smaller.

Let's start simple. Alice wants to send a bit to Bob, but she only has a qubit. This is pretty simple, she just sends the corresponding qubit, $\ket{0}$ for bit `0` and $\ket{1}$ for bit `1`. Bob measures with $Z$, gets the corresponding eigenvalue out, and he knows what bit Alice sent.

$$
\begin{aligned}
Z \ket{0}  & = \ket{0} \implies \lambda=+1 \implies \text{Alice sent a 0} \\
Z \ket{1}  & = -\ket{1} \implies \lambda=-1 \implies \text{Alice sent a 1}
\end{aligned}
$$

Pretty simple stuff.

Now let's say Alice wants to send 2 bits like in the previous example, but she only has one qubit. She could try sending one of $00\mapsto \ket{0}$, $01\mapsto \ket{1}$, $10\mapsto \ket{+}$ or $11\mapsto \ket{-}$, but that'll always be unclear to Bob what he received. If he tries measuring that with the $Z$ operator:

$$
\begin{aligned}
Z\ket{0}  & = \ket{0}  \\
Z\ket{1}  & = -\ket{1}  \\
Z\ket{+}  & = Z \frac{\ket{0} +\ket{1} }{\sqrt{ 2 }} = \frac{1}{\sqrt{ 2 }} \ket{0} -\frac{1}{\sqrt{ 2 }}\ket{1}  \\
Z\ket{-}  & = Z \frac{\ket{0} -\ket{1} }{\sqrt{ 2 }} = \frac{1}{\sqrt{ 2 }} \ket{0} +\frac{1}{\sqrt{ 2 }}\ket{1}
\end{aligned}
$$

and he gets $\lambda=+1$, all he knows now is that it's not $\ket{1}\mapsto 01$. There's still a pretty good chance it could be any of the other choices. That's because these 4 states aren't orthogonal to each other.

This might seem impossible at first glance, but the power of quantum entanglement saves the day yet again! Let's say Alice and Bob share a pair of particles in the same maximally entangled state as before:

$$
\frac{1}{\sqrt{ 2 }} [\ket{0} _{A}\ket{0} _{B}+\ket{1} _{A}\ket{1} _{B}]
$$

where $A$ represents Alice's qubit and $B$ represents Bob's qubit. Alice can then do one of 4 things to her qubit depending on the message she wants to send.

$$
\begin{aligned}
00 & \mapsto \text{act with } I \text{ (do nothing)} & \to \frac{1}{\sqrt{ 2 }}[\ket{0} _{A}\ket{0} _{B}+\ket{1} _{A}\ket{1} _{B}] = \ket{\Phi_{I}} \\
01 & \mapsto \text{act with } X  & \to \frac{1}{\sqrt{ 2 }} [\ket{1} _{A}\ket{0} _{B}+\ket{0} _{A}\ket{1} _{B}] = \ket{\Phi_{X}}  \\
10 & \mapsto \text{act with } Y  & \to \frac{1}{\sqrt{ 2 }} [\ket{1} _{A}\ket{0} _{B}-\ket{0} _{A}\ket{1} _{B}] = \ket{\Phi_{Y}}  \\
11 & \mapsto \text{act with } Z  & \to \frac{1}{\sqrt{ 2 }} [\ket{0} _{A}\ket{0} _{B}-\ket{1} _{A}\ket{1} _{B}] = \ket{\Phi_{Z}}
\end{aligned}
$$

Alice then sends her qubit. Now Bob has a 2 qubits in 1 of 4 possible orthonormal states, and all he needs to do is measure with a 2-qubit operator that has $\ket{\Phi_{I}}$, $\ket{\Phi_{X}}$, $\ket{\Phi_{Y}}$ and $\ket{\Phi_{Z}}$ as its eigenstates. The eigenvalue he gets from that will tell him _with certainty_ which message Alice sent.

Alice just managed to send 2 bits by sending 1 qubit! This coding is known as **super-dense coding**.

### Cloning

All this talk of teleportation and quantum computation is making me think of sci-fi, and sci-fi makes me think of cloning. Is cloning possible? And is it a good idea? Well I can't answer the second question, but I can try answering the first.

We can prove this by pretending that we have a quantum operator $C$ that does cloning. That means that if we apply $C$ to a pair of qubits, it should copy the first qubit into the second:

$$
X \ket{\phi} \ket{\Omega} = \ket{\phi} \ket{\phi}
$$

We want this operator to be universal, so $\ket{\psi}$ should be allowed to be any state. Now let's say we have a superposition state $(\ket{\psi}+\ket{\phi})$. This should be no problem for our cloning operator:

$$
C (\ket{\psi}+\ket{\phi}  )\ket{\Omega} = (\ket{\psi} +\ket{\phi} )(\ket{\psi} +\ket{\phi} )
$$

But wait a minute, since quantum operators are linear, we can expand those brackets out on the left hand side:

$$
C \ket{\psi} \ket{\Omega} + C \ket{\phi} \ket{\Omega} = \ket{\psi} \ket{\psi} +\ket{\phi} \ket{\phi}
$$

That's a contradiction! That's not what we wanted, our perfect little cloning operator doesn't work!

Reality is often disappointing. So cloning is not allowed, as specified by the aptly-named **no-cloning theorem**. I guess we won't have to answer that second question after all.

> [!note] Dolly the sheep
>
> You're probably thinking: what about Dolly the sheep? I read in the news that she was the first cloned animal, and yet you're here telling me that cloning isn't even real?
>
> Both things are true, they just have different versions of "cloning". There's nothing stopping you from cloning a cell, so long as the particles that make up that cell are different. The no-cloning theorem doesn't really apply for anything except quantum states. You can make a copy of every cell in your body, but it won't be a 100% atom-for-atom clone of you, which who knows what kinds of consequences that could end up having.

### CHSH game

Say you have a group of 4 friends: Alice, Bob, Carol and Dan. Alice and Bob want to meet on Saturday, but they each have a 50% chance of being visited by Carol and Dan, respectively. That's not an issue on its own, they can just bring Carol and/or Dan along, but actually Carol and Dan just went through a really bad fight and aren't on speaking terms, so if both of them show up, that would ruin the evening for everyone.

Alice and Bob meet up on Friday to devise a strategy. They have 2 locations they could go to: the park or the beach. If both Carol and Dan show up, Alice and Bob have to find a way to avoid each other. But if only one of them shows up, they have to find a way to meet up. They can't talk on Saturday because that would make Carol and Dan suspicious, so they have to decide what to do beforehand. They'll succeed if they avoid each other if both Carol and Dan show up, and if they meet up when one or neither of them show.

Let's start with a fairly simple strategy. Let's say they decide that Alice should go to the park regardless of whether Carol shows up or not. If Dan shows up, then Bob will go to the beach, otherwise he'll head to the park.

- If neither Carol nor Dan show up, then both Alice and Bob will meet at the park and have a nice evening.
- If only Carol shows up, then Alice, Carol and Bob will meet at the park and have a nice evening.
- If both Carol and Dan show up, then Alice and Carol will go to the park while Bob and Dan go to the beach, successfully avoiding each other.
- If only Dan shows up, then Alice will be alone at the park while Bob and Dan go to the beach.

This strategy works 75% of the time, which sounds pretty good.

In fact, any classical strategy will work at most 75% of the time. To prove this, let's convert this word problem to math.

Alice and Bob receive bits $x$ and $y$ each with equal probability. We can say that `0` represents their respective friend not showing up, while `1` represents them showing up.

Alice and Bob must then each produce a bit $a$ and $b$ of their own. Let's say `0` represents going to the park, while `1` represents going to the beach. They win if their bits satisfy the relation:

$$
a \oplus b = xy
$$

where the rules of $\oplus$ (addition modulo 2) are:

$$
\begin{aligned}
0 \oplus 0 & = 0 \\
0 \oplus 1 & = 1 \\
1 \oplus 0 & = 1 \\
1 \oplus 1 & = 0
\end{aligned}
$$

It's basically an `XOR`.

These are the 4 cases above:

- Neither Carol nor Dan show up, meet up at same place: $a_{0} \oplus b_{0} = 0 \times 0 = 0$, meaning $a_{0}=b_{0}$.
- Carol shows up but not Dan, meet up at the same place: $a_{1}\oplus b_{0}=1\times 0=0$, meaning $a_{1}=b_{0}$.
- Dan shows up but not Carol, meet up at the same place: $a_{0}\oplus b_{1}=0\times 1=0$, meaning $a_{0}=b_{1}$.
- Both Carol and Dan show up, meet at different places: $a_{1}\oplus b_{1}=1\times 1=1$, meaning $a_{1}\neq b_{1}$.

where

- $a_0$ is Alice's response when Carol doesn't show up ($x=0$)
- $a_1$ is Alice's response when Carol does show up ($x=1$)
- $b_0$ is Bob's response when Dan doesn't show up ($y=0$)
- $b_1$ is Bob's response when Dan does show up ($y=1$)

To prove that we can't win the game 100% of the time using any classical strategy, we can prove that there's no combination of values for $a_0$, $a_1$, $b_0$ and $b_1$ that work. To do that, we can simply add them up (modulo 2):

$$
\begin{aligned}
(a_{0}\oplus b_{0})\oplus (a_{1}\oplus b_{0})\oplus (a_{0}\oplus b_{1})\oplus (a_{1}\oplus b_{1}) & = 0\oplus 0\oplus 0\oplus 1 \\
(a_{0}\oplus a_{0})\oplus (a_{1}\oplus a_{1})\oplus (b_{0}\oplus b_{0})\oplus (b_{1}\oplus b_{1}) & = 1 \\
0\oplus 0\oplus 0\oplus 0 & = 1 \\
0 & = 1
\end{aligned}
$$

Here, we used the rule that $n\oplus n=0$, as we saw in the modulo 2 rules above. We ended up with the result $0 = 1$, which we know for a fact is nonsensical, and we didn't even assign any values to $a_0$, $a_1$, $b_0$ or $b_1$!

So that means that there don't exist any values where you can get 100% success, meaning out of our 4 equations at least one must not be satisfied, giving us an upper bound of 3/4 or 75% success, which we already achieved.

Now let's use the power of quantum entanglement to pump up those numbers!

As usual, we start with Alice and Bob sharing the maximally entangled state:

$$
\ket{\Phi} =\frac{\ket{0} \ket{0} +\ket{1} \ket{1} }{\sqrt{ 2 }}
$$

If Carol shows up, Alice measures her qubit with operator $A_1$, otherwise she uses $A_0$. Similarly, Bob uses $B_1$ on his qubit if Dan shows up, and $B_0$ otherwise. $A_0$, $A_1$, $B_0$ and $B_1$ all have eigenvalues $+1$ and $-1$, so to produce their answers $a$ and $b$, they use:

$$
\begin{aligned}
a & = \begin{cases}
0 & \text{if }\alpha=+1 \\
1 & \text{if }\alpha=-1
\end{cases} \\
b & = \begin{cases}
0 & \text{if }\beta=+1 \\
1 & \text{if }\beta=-1
\end{cases}
\end{aligned}
$$

where $\alpha$ and $\beta$ are the eigenvalues that Alice and Bob get from measuring their respective operator on their respective qubit.

The operators that Alice and Bob use are:

$$
\begin{aligned}
A_{0} & = X \\
A_{1} & = Z \\
B_{0} & = \frac{X+Z}{\sqrt{ 2 }} \\
B_{1} & = \frac{X-Z}{\sqrt{ 2 }}
\end{aligned}
$$

The thing we're actually measuring is the outcome after both Alice and Bob apply their operators:

$$
\begin{aligned}
\braket{ \Phi | A \otimes B | \Phi }  & = &  & \sum_{\alpha,\beta} \alpha \beta \Pr(\alpha,\beta) \\
 & = &  & \Pr(\alpha=+1,\beta=+1)-\Pr(\alpha=+1,\beta=-1) \\
 &  &  & - \Pr(\alpha=-1,\beta=+1)+\Pr(\alpha=-1,\beta=-1) \\
 & = &  & \Pr(\alpha=\beta)-\Pr(\alpha\neq\beta) \\
 & = &  & \Pr(\alpha=\beta)-(1-\Pr(\alpha=\beta)) \\
 & = &  & 2\Pr(\alpha=\beta)-1
\end{aligned}
$$

which we can rearrange to get:

$$
\Pr(\alpha=\beta)=\frac{1+\braket{ \Phi | A \otimes B | \Phi } }{2}
$$

> [!note] Expectation value
>
> The statement $\braket{ \Phi | A \otimes B | \Phi } = \sum_{\alpha,\beta} \alpha\beta\Pr(\alpha,\beta)$ comes from the fact that measurement of a quantum system is equivalent to finding the expectation value. It holds true for any state and pair of operators $A$ and $B$ with eigenvalues $\pm 1$, not just the particular ones we've chosen here.

Since both Alice and Bob decide to give the answer $0$ when their respective measurement outcome is $+1$, and $1$ when their respective measurement outcome is $-1$, we know that when $\alpha=\beta$, $a = b$. This means that we can rewrite that expression as

$$
\Pr(a \oplus b = 0|x,y) = \frac{1+\braket{ \Phi | A \otimes B | \Phi } }{2}
$$

and by using $\Pr(\alpha=\beta) + \Pr(\alpha\neq\beta)=1$:

$$
\begin{aligned}
\Pr(a\oplus b=1|x,y) & =1-\frac{1+\braket{ \Phi | A \otimes B |\Phi } }{2} \\
 & = \frac{1-\braket{ \Phi | A \otimes B |\Phi } }{2}
\end{aligned}
$$

Now we just have to find the values of $\braket{ \Phi | A \otimes B |\Phi }$. This calculation is going to be tedious if we try to do it manually, so let's try and simplify things a bit. Looking at our 4 operators, we can notice that they're basically the same operator with an angle on the $X$-$Z$ plane:

$$
\begin{aligned}
S(\theta) & = \cos(\theta)X + \sin(\theta)Z \\
S(0) & = \cos(0)X + \sin(0)Z = X \\
S\left( \frac{\pi}{4} \right) & = \cos\left( \frac{\pi}{4} \right)X + \sin\left( \frac{\pi}{4} \right)Z = \frac{X+Z}{\sqrt{ 2 }} \\
S\left( \frac{\pi}{2} \right) & = \cos\left( \frac{\pi}{2} \right)X+\sin\left( \frac{\pi}{2} \right)Z = Z \\
S\left( -\frac{\pi}{v} \right) & =\cos\left( -\frac{\pi}{4} \right)X+\sin\left( -\frac{\pi}{4} \right)Z = \frac{X-Z}{\sqrt{ 2 }}
\end{aligned}
$$

We can use this more general formula to simplify our expression, and since we know that our 4 operators are just special cases of this more general operator, we can plug in our angles for those later.

$$
\begin{aligned}
\braket{ \Phi | S(\theta)\otimes S(\phi)|\Phi }  & = &  & \braket{ \Phi | \cos(\theta)X+\sin(\theta)Z \otimes (\cos(\phi)X+\sin(\phi)Z) |\Phi }  \\
 & = &  & \cos(\theta)\cos(\phi)\braket{ \Phi | X \otimes X | \Phi }  \\
 &  &  & + \cos(\theta)\sin(\phi)\braket{ \Phi | X \otimes Z | \Phi }  \\
 &  &  & + \sin(\theta)\cos(\phi)\braket{ \Phi | Z \otimes X | \Phi }  \\
 &  &  & + \sin(\theta)\sin(\phi)\braket{ \Phi | Z \otimes Z | \Phi }
\end{aligned}
$$

We can simplify this a bit, knowing that $X \otimes X \ket{\Phi} = Z \otimes Z \ket{\Phi} + \ket{\Phi}$:

$$
\begin{aligned}
(X \otimes X) \frac{\ket{0} \ket{0} +\ket{1} \ket{1} }{\sqrt{ 2 }} & = \frac{\ket{1} \ket{1} +\ket{0} \ket{0} }{\sqrt{ 2 }} \\
 & = \ket{\Phi} \\
(Z \otimes Z) \frac{\ket{0} \ket{0} +\ket{1} \ket{1} }{\sqrt{ 2 }} & = \frac{\ket{0} \ket{0} + (-1)(-1)\ket{1} \ket{1}}{\sqrt{ 2 }} \\
 & = \frac{\ket{0} \ket{0} +\ket{1} \ket{1} }{\sqrt{ 2 }} \\
 & = \ket{\Phi}
\end{aligned}
$$

Similarly, we have $X \otimes Z \ket{\Phi}=\ket{\Psi}$ and $Z \otimes X \ket{\Phi} = -\ket{\Psi}$:

$$
\begin{aligned}
(X \otimes Z) \frac{\ket{0} \ket{0} +\ket{1} \ket{1} }{\sqrt{ 2 }} & = \frac{\ket{1} \ket{0} -\ket{0} \ket{1} }{\sqrt{ 2 }} \\
 & = \ket{\Psi}  \\
(Z \otimes X) \frac{\ket{0} \ket{0} +\ket{1} \ket{1} }{\sqrt{ 2 }} & = \frac{\ket{0} \ket{1} -\ket{1} \ket{0} }{\sqrt{ 2 }} \\
 & = -\ket{\Psi}
\end{aligned}
$$

where $\braket{ \Psi | \Phi }=\braket{ \Phi | \Psi }=0$, i.e. $\ket{\Phi}$ and $\ket{\Psi}$ are orthogonal.

Simplifying:

$$
\begin{aligned}
\braket{ \Phi | S(\theta)\otimes S(\phi)|\Phi }  & = &  & \cos(\theta)\cos(\phi)\braket{ \Phi | X \otimes X | \Phi }  \\
 &  &  & + \cos(\theta)\sin(\phi)\braket{ \Phi | X \otimes Z | \Phi }  \\
 &  &  & + \sin(\theta)\cos(\phi)\braket{ \Phi | Z \otimes X | \Phi }  \\
 &  &  & + \sin(\theta)\sin(\phi)\braket{ \Phi | Z \otimes Z | \Phi }  \\
 & = &  & \cos(\theta)\cos(\phi)\braket{ \Phi | \Phi }  \\
 &  &  & + \cos(\theta)\sin(\phi)\braket{ \Phi | \Psi }  \\
 &  &  & + \sin(\theta)\cos(\phi)\braket{ \Psi | \Phi }  \\
 &  &  & + \sin(\theta)\sin(\phi)\braket{ \Psi | \Psi }  \\
 & = &  & \cos(\theta)\cos(\phi)+\sin(\theta)\sin(\phi) \\
 & = &  & \cos(\theta-\phi)
\end{aligned}
$$

That last step comes from the trigonometry rule:

$$
\begin{aligned}
\cos(a+b) & =\cos(a)\cos(b)-\sin(a)\sin(b) \\
\cos(a-b) & =\cos(a)\cos(-b)-\sin(a)\sin(-b) \\
 & = \cos(a)\cos(b)+\sin(a)\sin(b)
\end{aligned}
$$

since $\cos(-x)=\cos(x)$ and $\sin(-x)=-\sin(x)$.

Let's plug this back in to our original formula:

$$
\begin{aligned}
\Pr(a \oplus b=0|x,y) & = \frac{1+\braket{ \Phi | S(\theta) \otimes S(\phi) | \Phi } }{2} \\
 & = \frac{1 + \cos(\theta-\phi)\braket{ \Phi | \Phi } }{2} \\ \\
 & = \frac{1+\cos(\theta-\phi)}{2}
\end{aligned}
$$

That's much better! We can plug in our operator angles and check each case:

$$
\begin{aligned}
\Pr(a \oplus b=0|x=0,y=0) & = \frac{\left( 1+\cos\left( 0-\frac{\pi}{4} \right) \right)}{2} \\
 & = \frac{\left( 1+\cos\left( -\frac{\pi}{4} \right) \right)}{2} \\
 & \approx 0.854 \\
\Pr(a \oplus b=0|x=0,y=1) & = \frac{\left( 1+\cos\left( 0-\left( -\frac{\pi}{4} \right) \right) \right)}{2} \\
 & = \frac{\left( 1+\cos\left( \frac{\pi}{4} \right) \right)}{2} \\
 & \approx 0.854 \\
\Pr(a \oplus b=0|x=1,y=0) & = \frac{\left( 1+\cos\left( \frac{\pi}{2}-\frac{\pi}{4} \right) \right)}{2} \\
 & = \frac{\left( 1+\cos\left( \frac{\pi}{4} \right) \right)}{2} \\
 & = \approx 0.854
\end{aligned}
$$

For the $x=1, y=1$ case, when both Carol and Dan show up, we want Alice and Bob to go to different places, meaning $a \oplus b=1$:

$$
\begin{aligned}
\Pr(a \oplus b=1|x=1,y=1) & =\frac{\left( 1-\cos\left( \frac{\pi}{2}-\left( -\frac{\pi}{4} \right) \right) \right)}{2} \\
 & = \frac{\left( 1-\cos\left( \frac{3\pi}{4} \right) \right)}{2} \\
 & \approx 0.854
\end{aligned}
$$

So we see that using this quantum strategy, Alice and Bob can **succeed approximately 85.4%** of the time! We just proved that a quantum strategy is significantly better than any classical strategy we could have found!

Whew, that's a lot of math! If you made it through all that, congratulations! If you just scrolled past it all and skipped to this point, I don't blame you.

> [!note] CHSH
>
> "CHSH" stands for Clauser, Horne, Shimony and Holt. They presented a simpler and more powerful version of [Bell's theorem](https://en.wikipedia.org/wiki/Bell's_theorem) about quantum nonlocality. The version presented here is the more modern framing in the form of a game. That's how it was first taught to me, though with a lot more math (if you can believe it) and a lot of details that I decided to skip here.

## Conclusion

I think I'll wrap it up there for now. There are a _lot_ of other things left that I could have covered, like Grover's algorithm, Shor's algorithm, quantum circuits, quantum cryptography, etc., but this post is more than long enough already, and I think most of you have probably left by now after seeing that wall of math. Maybe I'll end up writing about those things in the future.

I'm not sure if you can tell, but this kind of stuff really excites me. We have _mathematical proof_ that quantum computers are capable of doing things that classical computers aren't, and all of it is based entirely upon _linear algebra and complex numbers_! And that's just scratching the surface of what's possible!

I'd also like to mention [QCSim](https://github.com/noClaps/qcsim), a quantum computer simulator I built. Most of the stuff I've talked about in this post were what inspired me to build this, and in turn inspired me to look into quantum information and quantum computation as a career path in the first place.

Anyway, that's all I've got for now, seeya next time (hopefully sooner than 5 months lol)!
