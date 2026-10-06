#import "../utils.typ": note
#import "@preview/simple-plot:1.1.0"

#metadata((
  title: [A beginner's guide to Quantum Information],
  date: datetime(year: 2026, month: 10, day: 6),
))

#set math.mat(align: right)
#show hide: html.elem("mspace", attrs: (width: "0em"))

#let bra(..args) = $lr(#hide("|") chevron.l #args.pos().join($,$) |)$
#let ket(..args) = $lr(| #args.pos().join($,$) chevron.r #hide("|"))$
#let braket(..args) = $chevron.l #args.pos().join($mid(|)$) chevron.r$
#let ketbra(l, r) = $ket(#l) bra(#r)$
#simple-plot.set-plot-defaults(
  width: 10,
  height: 10,
  show-origin: false,
  tick-label-size: 0em,
  style: (plot: (samples: 750)),
)
#let plot(..args) = {
  html.frame(simple-plot.plot(..args))
}

#note(title: [Prerequisites])[
  This post assumes that you have knowledge of linear algebra, such as matrix and vector multiplications, eigenvectors and eigenvalues, etc. More advanced concepts like the Kronecker product will be explained briefly, but I won't go into too much detail about them. Knowledge of complex numbers and operations is also assumed.
]

Quantum computing is this hot new topic that's been around tech news in the last few years. There's claims flying around about how it's orders of magnitude faster than classical computers, and that it's going to break all of our encryption and cybersecurity. To be fair, a lot of that is true, to a certain extent. Quantum computers are much, much faster than classical computers *at certain tasks*, and there are in fact quantum algorithms that can break some *older* encryption schemes in a reasonable amount of time.

That said, quantum computing isn't a 1:1 replacement for classical computing; the way that quantum computers work is both very different and, at least to me, very fascinating. It's also not nearly as complicated as its often made to sound.

= The humble (qu)bit

Classical computers work on binary digits (a.k.a. bits), i.e. 0s and 1s. You've probably heard this a million times, but there's a key observation here that you might not have considered before. 0 and 1 are *discrete* values; if a bit isn't 0 it must be 1 and vice versa. We can call these the bit's "states": it can be in a state of 0 or a state of 1.

Qubits, on the other hand, aren't as straightforward. Bits are represented in hardware by low and high electrical signals, and qubits are represented by a two-level quantum mechanical system, like electron spin ("up" or "down"), or photon polarisation ("left-handed" or "right-handed"). However, due to the way that quantum mechanics works, these properties aren't inherently discrete.

An quantum mechanical system can exist in what's called a *superposition*, which is a separate, mixed state of its two discrete options. You'll often hear that it's "in both states at the same time" until you measure it, at which point the state collapses into one of its discrete options. But that's not fully accurate.

The way I understood it best is flipping a coin. While the coin is in the air flipping, it's not "heads" or "tails", it's in a third mixed state called "flipping". When the coin lands and you check it, its "flipping" state collapses into "heads" or "tails" with, assuming a fair coin, equal probability.

This isn't possible to model with a single bit, as a bit can only ever be 0 or 1, it can't ever be in that "flipping" state. However, a qubit can be, and we can write it as:

$
  1/sqrt(2) ket(0) + 1/sqrt(2) ket(1)
$

#note(title: [Notation])[
  $ket(0)$ is read as "ket 0", and it represents the part of the qubit's vector pointing in the $0$ direction. The counterpart to a "ket" is a "bra", written as $bra(0)$. Together they make "bra-ket" notation, also known as _Dirac notation_. It's important to remember, the "0" and "1" here are *just labels*, they aren't real values. We could have just as well named them $ket(h)$ and $ket(t)$ and all of the math would work out exactly the same.

  Defining a bra is a bit complicated, but you can imagine it as the counterpart to a ket. The mathematical application of it is that, when you apply a bra to a ket, if the labels inside both are the same, then they cancel out to 1, otherwise they cancel out to 0:

  $
    braket(0, 0) = braket(1, 1) = 1 \
    braket(0, 1) = braket(1, 0) = 0
  $

  Here, $braket(0, 0)$ is just a shorthand for $bra(0) ket(0)$, and you're effectively taking a dot product. We'll see this in closer detail when we look at #link(<quantum-computing-vector-notation>)[vector notation].
]

Here, $ket(0)$ and $ket(1)$ are the qubit's _basis states_. The definition of an eigenbasis is a bit complicated, but an easy way to imagine this is that a qubit exists on a unit circle, and these are the graph's $x$ and $y$ axes. The coefficients of the basis states then represent the actual $x$ and $y$ coordinates on that graph:

#figure(
  plot(
    xmin: -1.125,
    xmax: 1.125,
    ymin: -1.125,
    ymax: 1.125,
    xlabel: ket(0),
    ylabel: ket(1),
    (fn: x => calc.sqrt(1 - calc.pow(x, 2)), domain: (1, -1)),
    (fn: x => -calc.sqrt(1 - calc.pow(x, 2)), domain: (-1, 1)),
    (
      fn: x => x,
      domain: (0, calc.cos(45deg)),
      stroke: red,
      label: $1/sqrt(2) ket(0) + 1/sqrt(2) ket(1)$,
    ),
  ),
  caption: [
    The unit circle on the $ket(0)$-$ket(1)$ plane. Qubits lie somewhere on the blue line in this plane. The red line shows the vector for the $1/sqrt(2) ket(0) + 1/sqrt(2) ket(1)$ qubit lying halfway between the $ket(0)$ and $ket(1)$ axes.
  ],
)

#note(title: [Orthonormality])[
  The actual thing we're talking about here is called "orthonormality". This consists of two properties: orthogonality and normality. For an orthonormal eigenbasis:

  - *Orthogonality:* The basis vectors must be orthogonal, or at 90#sym.degree to each other. This is what I meant when I said they were the $x$ and $y$ axes of a graph. The way this is actually defined is that their inner product $braket(a, b) = 0$. This holds true for $ket(0)$ and $ket(1)$ since $braket(0, 1) = braket(1, 0) = 0$.
  - *Normality:* The basis vectors must be normal. A vector is considered "normal" if its inner product with itself $braket(v, v) = 1$. This must be true for any vector in the space, so any combination of the basis vectors. This is what I meant when I said that a qubit exists on the unit circle.

  So if two vectors $ket(a)$ and $ket(b)$ meet the condition:

  $
    braket(a, b) = cases(
      1 "if" a = b,
      0 "otherwise"
    )
  $

  then they are said to be orthonormal. While there are non-orthonormal eigenbases, we'll only be talking about orthonormal bases in this post.
]

In reality, the coefficients of the $ket(0)$ and $ket(1)$ are complex numbers, so even drawing a single qubit would actually require a 4-dimensional graph. I don't know how to make 4D graphs, so I'm just going to stick with this simplified example for now. Besides, it's not very useful to work with qubits on graphs since, as you can see, you run out of dimensions pretty quickly.

However, this graphical representation shows that qubits can be written as vectors using their coefficients:

$
  a_0 ket(0) + a_1 ket(1) = vec(a_0, a_1)
$ <quantum-computing-vector-notation>

#note(title: [Vector definition of $bra(psi)$])[
  Now that we have our vector definitions for $ket(psi)$, we can better define $bra(psi)$. If $ket(psi)$ is a vertical vector, then $bra(psi)$ is a horizontal vector, such that:

  $
            bra(psi) & = a_0 bra(0) + a_1 bra(1) = mat(a_0, a_1) \
            ket(phi) & = b_0 ket(0) + b_1 ket(1) = vec(b_0, b_1) \
    braket(psi, phi) & = mat(a_0, a_1) dot vec(b_0, b_1) = a_0 b_0 + a_1 b_1
  $

  We could derive the same result by doing the multiplication algebraically:

  $
    braket(psi, phi) & = (a_0 bra(0) + a_1 bra(1)) (b_0 ket(0) + b_1 ket(1)) \
                     & = a_0 b_0 braket(0, 0) + a_0 b_1 braket(0, 1) + a_1 b_0 braket(1, 0) + a_1 b_1 braket(1, 1) \
                     & = a_0 b_0 times 1 + a_0 b_1 times 0 + a_1 b_0 times 0 + a_1 b_1 times 1 \
                     & = a_0 b_0 + a_1 b_1
  $

  I'm going to use both Dirac notation and vector notation interchangeably throughout this post since it's sometimes easier to do calculations with one or the other, so it's worth getting familiar with translating between both.
]

== Measuring a qubit <quantum-computation-measuring-a-qubit>

When we measure a qubit, we're collapsing it down from its superposition state down to one of its basis states. To do that, we're going to use the coefficient of each basis state, also known as the *amplitude*. The square of the amplitude represents the probability that, when measured, the qubit will collapse into that state:

$
  ket(psi) = a_0 ket(0) + a_1 ket(1) \
  Pr(0) = abs(a_0)^2 \
  Pr(1) = abs(a_1)^2
$

So for the $1/sqrt(2) ket(0) + 1/sqrt(2) ket(1)$ case, we can say that $ket(0)$ represents "heads" and $ket(1)$ represents tails. The probability of each would be:

$
  Pr(0) = abs(1/sqrt(2))^2 = 1/2 \
  Pr(1) = abs(1/sqrt(2))^2 = 1/2
$

thus representing our fair coin's 50/50 chance of heads or tails.

This brings with it another key observation: *the sum of the squares of the amplitudes must equal 1*. If we have a qubit $ket(psi) = a_0 ket(0) + a_1 ket(1)$, then the probability of measuring $0$ is $abs(a_0)^2$ and the probability of measuring $1$ is $abs(a_1)^2$. Since measuring must return _something_, the total probability must equal 100%, and therefore:

$
  Pr(0) + Pr(1) + ... = abs(a_0)^2 + abs(a_1)^2 + ... = 1
$

#note(title: [Derivation of $braket(psi, psi) = 1$])[
  Using our vector definitions as well as our new sum of squares rule, we can also show how $braket(psi, psi) = 1$:

  $
            ket(psi) & = vec(a_0, a_1) \
    braket(psi, psi) & = mat(a_0, a_1) vec(a_0, a_1) \
                     & = a_0 times a_0 + a_1 times a_1 \
                     & = abs(a_0)^2 + abs(a_1)^2 \
                     & = 1
  $

  Note that we didn't specify any values of $a_0$ or $a_1$, so this applies to any quantum state, including basis states:

  $
    ket(0) & = vec(1, 0) => braket(0, 0) = 1^2 + 0^2 = 1 \
    ket(1) & = vec(0, 1) => braket(0, 1) = 0^2 + 1^2 = 1
  $
]

Now that we have our qubits, we want to be able to do something with them. To do that, we use operators.

= Operators

In classical computing, there are a number of operators, or *gates*, that can act on bits, which can be written out as truth tables. For example, the `NOT` operator, which inverts the bit:

#table(
  columns: 2,
  table.header([$A$], [$not A$]),
  $0$, $1$,
  $1$, $0$,
)

Similarly, there are a number of quantum operators that can act on qubits. The quantum analogue to the classical `NOT` operator is the Pauli X operator:

$
  X = mat(0, 1; 1, 0) = ketbra(0, 1) + ketbra(1, 0)
$

#note(title: [Vector derivation])[
  We can derive the $X$ operator using the vector forms of $ket(psi)$ and $bra(psi)$:

  $
    X & = ketbra(0, 1) + ketbra(1, 0) \
      & = vec(1, 0) mat(0, 1) + vec(0, 1) mat(1, 0) \
      & = mat(0, 1; 0, 0) + mat(0, 0; 1, 0) \
      & = mat(0, 1; 1, 0)
  $
]

The way to apply an operator is to take the dot product with the qubit you want to apply it to:

$
  X ket(0) & = (ketbra(0, 1) + ketbra(1, 0)) ket(0) \
           & = ket(0) braket(1, 0) + ket(1) braket(0, 0) \
           & = ket(1)
$

or in vector notation:

$
  mat(0, 1; 1, 0) vec(1, 0) & = vec(0 times 1 + 1 times 0, 1 times 1 + 0 times 0) \
                            & = vec(0, 1) = ket(1)
$

Below is a brief list of common single-qubit quantum operators:

#table(
  columns: 4,
  table.header([Name], [Symbol], [Matrix], [Dirac]),
  "Hadamard",
  $H$,
  $1/sqrt(2) mat(1, 1; 1, -1)$,
  $1/sqrt(2) (ketbra(0, 0) + ketbra(0, 1) + ketbra(1, 0) - ketbra(1, 1))$,

  "Pauli X", $X$, $mat(0, 1; 1, 0)$, $ketbra(0, 1) + ketbra(1, 0)$,
  "Pauli Y", $Y$, $mat(0, -i; i, 0)$, $-i ketbra(0, 1) + i ketbra(1, 0)$,
  "Pauli Z", $Z$, $mat(1, 0; 0, -1)$, $ketbra(0, 0) - ketbra(1, 1)$,
  "Identity", $I$, $mat(1, 0; 0, 1)$, $ketbra(0, 0) + ketbra(1, 1)$,
) <quantum-computing-common-operators>

= Multiple qubits

Just as adding more classical bits makes it easier to perform larger calculations, adding more qubits makes a quantum computer more powerful. But now we have to worry about how to handle all of these qubits! Turns out, this isn't that difficult (at least mathematically), we just put them together!

We can combine multiple qubits by taking their Kronecker product:

$
  ket(0) times.o ket(0) times.o ... times.o ket(0)
$

However, that's tedious to write, so there are shorter forms of this:

$
  ket(0) ket(0) ... ket(0) = ket(00 ... 0)
$

For example, a 2-qubit state can be written as:

$
  ket(0) times.o ket(0) = ket(0) ket(0) = ket(00)
$

#note(title: [Kronecker product])[
  The Kronecker product, also known as the tensor product, is denoted by $times.o$ and is an operation on a vector or matrix that increases its size. The way it works is pretty simple, you just multiply the right hand side by each element of the left hand side:

  $
                     ket(phi) & = vec(a_0, a_1) \
                     ket(psi) & = vec(b_0, b_1) \
    ket(phi) times.o ket(psi) & = vec(a_0 dot ket(psi), a_1 dot ket(psi)) \
                              & = vec(a_0 dot vec(b_0, b_1), a_1 dot vec(b_0, b_1)) \
                              & = vec(a_0 times b_0, a_0 times b_1, a_1 times b_0, a_1 times b_1)
  $

  For instance, let's take the tensor product $ket(0) times.o ket(0)$:

  $
                   ket(0) & = vec(1, 0) \
    ket(0) times.o ket(0) & = vec(1, 0) times.o vec(1, 0) \
                          & = vec(1 dot vec(1, 0), 0 dot vec(1, 0)) \
                          & = vec(1 times 1, 1 times 0, 0 times 1, 0 times 0) \
                          & = vec(1, 0, 0, 0)
  $

  If we have two qubits and we take their Kronecker product, we can write the output in a form known as *product form*:

  $
              ket(alpha) & = a_0 ket(0) + a_1 ket(1) \
               ket(beta) & = b_0 ket(0) + b_1 ket(1) \
    ket(alpha) ket(beta) & = a_0 b_0 ket(00) + a_0 b_1 ket(01) + a_1 b_0 ket(10) + a_1 b_1 ket(11) \
                         & = vec(a_0 b_0, a_0 b_1, a_1 b_0, a_1 b_1)
  $
] <quantum-computing-kronecker-product>

As before, any multiple-qubit state can be written in vector notation as well. For example, a two qubit state:

$
  ket(psi) & = a_00 ket(00) + a_01 ket(01) + a_10 ket(10) + a_11 ket(11) \
           & = vec(a_00, a_01, a_10, a_11)
$

= Entanglement

Entanglement is a property that allows qubits to combine together into a single combined state. Before we explore that, we need to understand what defines entanglement.

To start, let's try writing this qubit in product form:

$
  ket(Phi) = & (ket(00) + ket(11))/sqrt(2) \
           = & a_0 b_0 ket(00) + a_0 b_1 ket(01) + a_1 b_0 ket(10) + a_1 b_1 ket(11)
$

Here, $a_0 b_0 = a_1 b_1 = 1/sqrt(2)$ and $a_0 b_1 = a_1 b_0 = 0$. That in turn implies that either $a_0$ or $b_1$ must be zero, and either $a_1$ or $b_0$ must be zero.

- If $a_0 = 0$, then $a_0 b_0 = 0$.
- If $a_1 = 0$, then $a_1 b_1 = 0$.
- If $b_0 = 0$, then $a_0 b_0 = 0$.
- If $b_1 = 0$, then $a_1 b_1 = 0$.

Uh oh, we've hit a roadblock! No matter what values for $a_0$, $a_1$, $b_0$ and $b_1$ we choose, we will never get this state. Since we cannot separate the state into its individual qubits, we say that this state is *entangled*. In fact, this specific state is known as the "maximally entangled state".

Let's look at a non-entangled state for comparison:

$
  ket(psi) = & (ket(00) + ket(10))/sqrt(2) \
           = & a_0 b_0 ket(00) + a_0 b_1 ket(01) + a_1 b_0 ket(10) + a_1 b_1 ket(11)
$

Here, $a_0 b_0 = a_1 b_0 = 1/sqrt(2)$ and $a_0 b_1 = a_1 b_1 = 0$, meaning that either $a_0$ or $b_1$ must be zero, and either $a_1$ or $b_1$ must be zero. From that, we can see quite easily that setting $b_1 = 0$ solves our problem.

$
   a_0 b_1 & = a_1 b_1 = 0 \
  ket(psi) & = a_0 b_0 ket(00) + 0 ket(01) + a_1 b_0 ket(10) + 0 ket(11) \
           & = a_0 b_0 ket(00) + a_1 b_0 ket(10)
$

Separating out the original qubit:

$
       ket(psi) & = ((ket(0) + ket(1))/sqrt(2)) ket(0) \
      => ket(a) & = (ket(0) + ket(1))/sqrt(2) \
         ket(b) & = ket(0) \
  ket(a) ket(b) & = (ket(00) + ket(10))/sqrt(2) = ket(psi)
$

Entanglement means that the qubits are linked together into *one single system*. Affecting one affects the other instantly; you can't change them individually. Physically, this is a bit complicated, but you can imagine a long invisible rod that's connecting the two particles, where moving one end of the rod moves the other end instantly.

Where this analogy falls apart is that it assumes a perfectly rigid object, which doesn't exist. Every material on Earth is made up of molecules that are held together by electromagnetic forces, and the speed at which the movement of one molecule affects the next is basically just the speed of sound in that material, since sound is simply a wave of pushing molecules in its direction of travel. However, making changes (applying operators) to entangled qubits is genuinely instant.

We'll explore some of the consequences of this later. For now, since we have a good understanding of how multiple-qubit systems work, we can look at how to apply operators onto them.

= Multiple qubit operators

Just as you could apply operators to a single qubit, you can apply them to multiple qubits at the same time. We can start by applying a single-qubit gate to a two-qubit state:

$
  X ket(10) & = mat(0, 1; 1, 0) vec(0, 0, 1, 0) \
            & = (ketbra(0, 1) + ketbra(1, 0)) ket(10) \
            & = ket(0) braket(1, 10) + ket(1) braket(0, 10)
$

Uh oh, we seem to have hit another roadblock! Since this is a single-qubit gate, it can only be applied to a single qubit. In order to apply an operator to a two-qubit state, we need to make it a two-qubit gate. We can do this by using the #link(<quantum-computing-kronecker-product>)[tensor product] again:

$
  (X times.o I) ket(10) = ket(00)
$

The way this works is that, going from left to right, the first gate applies to the first qubit, the second gate applies to the second qubit, and so on.

#note(title: [Derivation])[
  We can again derive this using both vector and Dirac notations.

  Vector notation:

  $
                        X & = mat(0, 1; 1, 0) \
                        I & = mat(1, 0; 0, 1) \
              X times.o I & = mat(0 dot I, 1 dot I; 1 dot I, 0 dot I) \
                          & = mat(
                              0, 0, 1, 0;
                              0, 0, 0, 1;
                              1, 0, 0, 0;
                              0, 1, 0, 0;
                            ) \
                  ket(10) & = vec(0, 0, 1, 0) \
                          \
    (X times.o I) ket(10) & = mat(
                              0, 0, 1, 0;
                              0, 0, 0, 1;
                              1, 0, 0, 0;
                              0, 1, 0, 0;
                            ) vec(0, 0, 1, 0) \
                          & = vec(1, 0, 0, 0) \
                          & = ket(00)
  $

  Dirac notation:

  $
    X times.o I & = (ketbra(0, 1) + ketbra(1, 0)) times.o (ketbra(0, 0) + ketbra(1, 1)) \
    & = ketbra(00, 10) + ketbra(01, 11) + ketbra(10, 00) + ketbra(11, 01) \
    \
    (X times.o I) ket(10)
    & = (ketbra(00, 10) + ketbra(01, 11) + ketbra(10, 00) + ketbra(11, 01)) ket(10) \
    & = ket(00) braket(10, 10) + ket(01) braket(11, 10) + ket(10) braket(00, 10) + ket(11) braket(01, 10) \
    & = ket(00) times 1 + ket(01) times 0 + ket(10) times 0 + ket(11) times 0 \
    & = ket(00)
  $

  When you're doing the tensor product $ketbra(a, b) times.o ketbra(p, q)$, you can pull the $ket(a)$ and $bra(b)$ through to their respective ket and bra on the other side:

  $
    ketbra(a, b) times.o ketbra(p, q) & = (ket(a) times.o ket(p)) (bra(b) times.o bra(q)) \
                                      & = ketbra(a p, b q)
  $
]

We can apply individual operators on individual qubits, but that doesn't get us very far. For the true power of quantum computing, we need to be able to entangle qubits. For that, we need a truly multi-qubit operator. One common example is the controlled `NOT`, or the $"CNOT"$ operator. Since we know that the $X$ gate is the quantum analogue to the `NOT` gate, this is also sometimes called the $"CX"$ operator.

$
  "CX" & = ketbra(00, 00) + ketbra(01, 01) + ketbra(10, 11) + ketbra(11, 10) \
       & = mat(
           1, 0, 0, 0;
           0, 1, 0, 0;
           0, 0, 0, 1;
           0, 0, 1, 0;
         )
$

The way this works is, when applied to a two-qubit state, it'll apply a `NOT` onto the second qubit if the first qubit is a $ket(1)$.

$
  "CX" ket(00) = ket(00) \
  "CX" ket(01) = ket(01) \
  "CX" ket(10) = ket(11) \
  "CX" ket(11) = ket(10)
$

As you can see, when the first qubit is a $ket(1)$, such as in the $ket(10)$ and $ket(11)$ cases, the second qubit gets toggled ($ket(10) -> ket(11)$ and $ket(11) -> ket(10)$, respectively).

Gates like these are the *only way to get entangled qubits*, you cannot get them from combining single-qubit gates alone. To see how, let's look at the maximally entangled state again:

$
  ket(Phi) = (ket(00) + ket(11))/sqrt(2)
$

How would we go about making this state? Well let's start from a very simple state: the $ket(00)$. If we have a look at the #link(<quantum-computing-common-operators>)[single-qubit operators table] from earlier, we can see that the Hadamard looks like it'll get us about halfway there. So let's apply a $H times.o I$ to this state.

$
  H times.o I ket(00) & = (ket(0) + ket(1))/sqrt(2) ket(0) \
                      & = (ket(00) + ket(10))/sqrt(2)
$

Ooh, so close. We just need a way to turn that $ket(10)$ into a $ket(11)$. Let's try applying an $X$ gate on the second qubit, so an $I times.o X$:

$
  I times.o X (ket(00) + ket(10))/sqrt(2) = (ket(01) + ket(11))/sqrt(2)
$

Well that solved our $ket(11)$ problem, but it left us with a $ket(01)$ instead. We need something that'll apply an $X$, but only when that first qubit is a $ket(1)$. So let's use our handy dandy $"CNOT"$!

$
  "CNOT" (ket(00) + ket(10))/sqrt(2) = (ket(00) + ket(11))/sqrt(2)
$

We got it! As you can see, there's no single qubit gate that could've done that, so we required a multiple-qubit gate like the $"CNOT"$. Any combination of single-qubit gates would be of the form $U times.o V$, which cannot entangle qubits since they act separately on individual qubits. Whereas multiple-qubit gates act on the entire multiple-qubit state at once to entangle it.

And that's it! That's all of the basic math of quantum computation. Everything we do from now on will be based on various applications of these basic rules. Pretty much all of quantum computation is based on these fairly simple (though not always easy) matrix multiplications.

#note(title: [Universal gate set])[
  A fairly well-known fact about classical computing is that #link("https://en.wikipedia.org/wiki/NAND_logic")[all bit operations can be implemented with just the `NAND` gate]. This is pretty easy to prove, you could probably do it yourself if you know your logic gates, #link("https://nandgame.com")[there's even a whole game about it]!

  Similarly, there exists a minimal set of quantum gates, known as the #link("https://en.wikipedia.org/wiki/Quantum_logic_gate#Universal_quantum_gates")[universal gate set], that can be used to make every other operator. The smallest one found so far is the #link("https://en.wikipedia.org/wiki/Toffoli_gate")[Toffoli gate] and the Hadamard gate. However, the #link("https://arxiv.org/abs/quant-ph/0301040")[proof for this] isn't as straightforward as that for the `NAND` gate.
]

= Measurement

We talked briefly about #link(<quantum-computation-measuring-a-qubit>)[measuring a qubit earlier], but let's dive a little deeper into what that actually means.

== Spectral decomposition

Before we talk about measurement, we have to talk about spectral decomposition. This is basically breaking down an $n$-by-$n$ operator into the form:

$
  U = sum_(i=0)^(n-1) lambda_i ketbra(v_i, v_i)
$

where $lambda_i$ are known as the *eigenvalues*. These eigenvalues are the things that we can observe, not the actual qubit values $ket(0)$ and $ket(1)$ themselves, since remember, *those are just labels*. Let's try to get the spectral decomposition of the Pauli $X$ operator. Since $X$ is a 1-qubit operator, $n=2$. For 2-qubit operators, $n=4$; for 3 qubits, $n=8$, and so on.

$
  X & = sum_(i=0)^1 lambda_i ketbra(v_i, v_i) \
    & = lambda_0 ketbra(v_0, v_0) + lambda_1 ketbra(v_1, v_1)
$

We can't do this in the $ket(0)$ and $ket(1)$ eigenbasis because $ket(v_i)$ and $bra(v_i)$ can't have the same label, while $lambda_0$ and $lambda_1$ will both be $+1$:

$
  X = ketbra(0, 1) + ketbra(1, 0)
$

Looks like we'll need to use a different one. Let's look at the $ket(+)$ and $ket(-)$ eigenbasis, where:

$
  ket(+) & = (ket(0) + ket(1))/sqrt(2) \
  ket(-) & = (ket(0) - ket(1))/sqrt(2)
$

#note(title: [Orthonormality])[
  We can prove that this eigenbasis is orthonormal.

  $
    braket(+, -) & = (bra(0) + bra(1))/sqrt(2) (ket(0) - ket(1))/sqrt(2) \
                 & = (braket(0, 0) - braket(0, 1) + braket(1, 0) - braket(1, 1))/2 \
                 & = (1 - 0 + 0 - 1)/2 \
                 & = 0 \
    braket(+, +) & = (bra(0) + bra(1))/sqrt(2) (ket(0) + ket(1))/sqrt(2) \
                 & = (braket(0, 0) + braket(0, 1) + braket(1, 0) + braket(1, 1))/2 \
                 & = (1 + 0 + 0 + 1)/2 \
                 & = 1
  $

  Proving this for $braket(-, +)$ and $braket(-, -)$ is left as an exercise to the reader ;)
]

Relabelling $0$ to $+$ and $1$ to $-$, we can write $X$ as:

$
  X = lambda_+ ketbra(v_+, v_+) + lambda_- ketbra(v_-, v_-)
$

Let's try using $ket(v_+) = ket(+)$ and $ket(v_-) = ket(-)$:

$
  X & = lambda_+ ketbra(+, +) + lambda_- ketbra(-, -) \
  & = lambda_+ (ketbra(0, 0) + ketbra(0, 1) + ketbra(1, 0) + ketbra(1, 1))/2 + lambda_- (ketbra(0, 0) - ketbra(0, 1) - ketbra(1, 0) + ketbra(1, 1))/2
$

Setting $lambda_+ = +1$ and $lambda_- = -1$, we get:

$
  X & = (ketbra(0, 0) + ketbra(0, 1) + ketbra(1, 0) + ketbra(1, 1))/2 - (ketbra(0, 0) - ketbra(0, 1) - ketbra(1, 0) + ketbra(1, 1))/2 \
  & = (2 ketbra(0, 1) + 2 ketbra(1, 0))/2 \
  & = ketbra(0, 1) + ketbra(1, 0)
$

which was our original definition for $X$.

We now have our two eigenvalues $lambda_+ = +1$ and $lambda_- = -1$ that we can use when measuring a qubit with $X$. The way to get the probability of these eigenvalues is by using something called the *projector*. That's just the $ketbra(v_i, v_i)$ state we saw in the spectral decomposition. So the projectors for $lambda_+$ and $lambda_-$ are:

$
  lambda_+ & => P_+ = ketbra(+, +) \
  lambda_- & => P_- = ketbra(-, -) \
$

== Measurement

Measurement is just the application of an operator in a given basis. For example, we can take the Pauli $X$ operator again. We use the spectral decomposition:

$
         X & = lambda_+ P_+ + lambda_- P_- \
           & = ketbra(+, +) - ketbra(-, -) \
  lambda_+ & = +1 \
       P_+ & = ketbra(+, +) \
  lambda_- & = -1 \
       P_- & = ketbra(-, -) \
$

The probability of the measurement outcome $lambda_+ = +1$ is then given by:

$
  braket(psi, P_+, psi)
$

where $ket(psi)$ is the state you're trying to measure. So for the $ket(0)$ state:

$
  braket(0, P_+, 0) & = braket(0, [ketbra(+, +)], 0) \
                    & = braket(0, +) braket(+, 0) \
                    & = bra(0) (ket(0) + ket(1))/sqrt(2) (bra(0) + bra(1))/sqrt(2) ket(0) \
                    & = (braket(0, 0) + braket(0, 1))/sqrt(2) (braket(0, 0) + braket(1, 0))/sqrt(2) \
                    & = 1/sqrt(2) times 1/sqrt(2) \
                    & = 1/2
$

So when measuring with $X$, there is a 50% chance of seeing a $+1$ when you have a $ket(0)$. Conversely, the probability of getting a $-1$ outcome is also 50%:

$
  braket(0, P_-, 0) & = braket(0, [ketbra(-, -)], 0) \
                    & = braket(0, -) braket(-, 0) \
                    & = bra(0) (ket(0) - ket(1))/sqrt(2) (bra(0) - bra(1))/sqrt(2) ket(0) \
                    & = (braket(0, 0) - braket(0, 1))/sqrt(2) (braket(0, 0) - braket(1, 0))/sqrt(2) \
                    & = 1/sqrt(2) times 1/sqrt(2) \
                    & = 1/2
$

You'd get the same values when trying to measure the $ket(1)$ state with $X$.

= Applications

By playing around with some quantum computing applications, we can get a better sense of what it's good for and what its limitations are. The math in this section gets a lot more involved than what we've been doing so far, so keep that in mind and make sure you're fairly comfortable with everything before this point.

== Teleportation

Let's say we have our two classic characters, Alice and Bob. Alice wants to send a message to Bob, but Bob, being about a light year away at Proxima Centauri, is _really_ far away, so I don't think the post will work. She thinks about using email, but email is, at best, limited by the speed of light, meaning it'll still take a year for the email to reach Bob. Suddenly, she remembers that she and Bob share a maximally entangled state:

$
  1/sqrt(2) [ket(0)_(A_1) ket(0)_B + ket(1)_(A_1) ket(1)_B]
$

where the $A_1$ subscript is Alice's qubit, and $B$ is Bob's qubit. Knowing that quantum entanglement works instantly, could she use this to send her message?

Let's say Alice's message is the unknown state $ket(psi) = a ket(0)_A + b ket(1)_A$. The complete state is then

$
  [a ket(0)_A + b ket(1)_A] 1/sqrt(2) [ket(0)_(A_1) ket(0)_B + ket(1)_(A_1) ket(1)_B]
$

which can be expanded out to

$
  & 1/(2 sqrt(2)) [ket(0)_A ket(0)_(A_1) + ket(1)_A ket(1)_(A_1)] [a ket(0)_B + b ket(1)_B] \
  & + 1/(2 sqrt(2)) [ket(0)_A ket(0)_(A_1) - ket(1)_A ket(1)_(A_1)] [a ket(0)_B - b ket(1)_B] \
  & + 1/(2 sqrt(2)) [ket(0)_A ket(1)_(A_1) + ket(1)_A ket(0)_(A_1)] [b ket(0)_B + a ket(1)_B] \
  & + 1/(2 sqrt(2)) [ket(0)_A ket(1)_(A_1) - ket(1)_A ket(0)_(A_1)] [-b ket(0)_B + a ket(1)_B]
$

Alice then measures her two-qubit state, the one with the $ket(u)_A ket(v)_(A_1)$, with an operator such that it has 4 different eigenvalues $lambda_1$, $lambda_2$, $lambda_3$ and $lambda_4$ corresponding to each of the states.

$
  1/sqrt(2) [ket(0)_A ket(0)_(A_1) + ket(1)_A ket(1)_(A_1)] = & ket(Phi_I) \
  1/sqrt(2) [ket(0)_A ket(0)_(A_1) - ket(1)_A ket(1)_(A_1)] = & ket(Phi_Z) \
  1/sqrt(2) [ket(0)_A ket(1)_(A_1) + ket(1)_A ket(0)_(A_1)] = & ket(Phi_X) \
  1/sqrt(2) [ket(0)_A ket(1)_(A_1) - ket(1)_A ket(0)_(A_1)] = & -ket(Phi_Y) \
$

You'll notice these look pretty similar to the $I$, $Z$, $X$ and $Y$ gates we saw earlier.

All of this probably sounds a bit confusing, but notice what happened to Bob's state above. All of those look kind of like that $ket(psi)$ state we started out with. In fact, based on what eigenvalue Alice finds from her measurement, she knows which state Bob got:

$
  lambda_1 & -> [a ket(0)_B + b ket(1)_B] \
  lambda_2 & -> [a ket(0)_B - b ket(1)_B] \
  lambda_3 & -> [b ket(0)_B + a ket(1)_B] \
  lambda_4 & -> [-b ket(0)_B + a ket(1)_B] &
$

since it's just the corresponding state from her $ket(Phi)$ state above. So if she got $lambda_1$ for instance, she got the state that has $[ket(0)_A ket(0)_(A_1) + ket(1)_A ket(1)_(A_1)]$ since that's the vector that corresponds to that eigenvalue. Since her and Bob's qubits are entangled, Bob therefore must have gotten the other half of that state, $[a ket(0)_B + b ket(1)_B]$.

However, Bob doesn't know this yet. As far as he knows, he could still have any of the 4 possibilities:

$
  1/2 [a ket(0)_B + b ket(1)_B] \
  1/2 [a ket(0)_B - b ket(1)_B] \
  1/2 [b ket(0)_B + a ket(1)_B] \
  1/2 [-b ket(0)_B + a ket(1)_B] \
  \
  Pr = abs(1/2)^2 = 1/4
$

with equal probability $Pr = abs(1/2)^2 = 1/4$. However, based on the eigenvalue that Alice measures, she can send him a 2 bit message to tell him which operator to measure with.

$
  lambda_1 & -> 00 && -> "measure" I "(do nothing)" \
  lambda_2 & -> 01 && -> "measure" Z \
  lambda_3 & -> 10 && -> "measure" X \
  lambda_4 & -> 11 && -> "measure" Y \
$

Following these instructions, Bob can get $ket(psi)$ back in all cases:

$
   I [a ket(0)_B + b ket(1)_B] & = [a ket(0)_B + b ket(1)_B] \
   Z [a ket(0)_B - b ket(1)_B] & = [a ket(0)_B + b ket(1)_B] \
   X [b ket(0)_B + a ket(1)_B] & = [b ket(1)_B + a ket(0)_B] = [a ket(0)_B + b ket(1)_B] \
  Y [-b ket(0)_B + a ket(1)_B] & = [b ket(1)_B + a ket(0)_B] = [a ket(0)_B + b ket(1)_B]
$

There's a factor of $i$ in the last case but we can just ignore it.

Now you may be thinking, how exactly is Alice meant to send the 2 bit message to Bob? I thought we were doing all this to send a message instantly and avoid that pesky speed of light limit. Well the truth is, you can't. Even though Alice knew which state Bob had, since Bob never got that knowledge, there was *no information transfer faster than the speed of light*. I'm sure Einstein is very pleased with this.

== Super-dense coding

Although we couldn't send messages faster than light, we can make the message itself smaller.

Let's start simple. Alice wants to send a bit to Bob, but she only has a qubit. This is pretty simple, she just sends the corresponding qubit, $ket(0)$ for bit `0` and $ket(1)$ for bit `1`. Bob measures with $Z$, gets the corresponding eigenvalue out, and he knows what bit Alice sent.

$
  Z ket(0) & = ket(0) => lambda = +1 => "Alice sent a 0" \
  Z ket(1) & = -ket(1) => lambda = -1 => "Alice sent a 1"
$

Pretty simple stuff.

Now let's say Alice wants to send 2 bits like in the previous example, but she only has one qubit. She could try sending one of $00 -> ket(0)$, $01 -> ket(1)$, $10 -> ket(+)$ or $11 -> ket(-)$, but that'll always be unclear to Bob what he received. If he tries measuring that with the $Z$ operator:

$
  Z ket(0) & = ket(0) \
  Z ket(1) & = -ket(1) \
  Z ket(+) & = Z (ket(0) + ket(1))/sqrt(2) = 1/sqrt(2) ket(0) - 1/sqrt(2) ket(1) \
  Z ket(-) & = Z (ket(0) - ket(1))/sqrt(2) = 1/sqrt(2) ket(0) + 1/sqrt(2) ket(1)
$

and he gets $lambda = +1$, all he knows now is that it's not $ket(1) -> 01$. There's still a pretty good chance it could be any of the other choices. That's because these 4 states aren't orthogonal to each other.

This might seem impossible at first glance, but the power of quantum entanglement saves the day yet again! Let's say Alice and Bob share a pair of particles in the same maximally entangled state as before:

$
  1/sqrt(2) [ket(0)_A ket(0)_B + ket(1)_A ket(1)_B]
$

where $A$ represents Alice's qubit and $B$ represents Bob's qubit. Alice can then do one of 4 things to her qubit depending on the message she wants to send.

$
  00 & -> "act with" I "(do nothing)" & -> 1/sqrt(2) [ket(0)_A ket(0)_B + ket(1)_A ket(1)_B] = ket(Phi_I) \
  01 & -> "act with" X                & -> 1/sqrt(2) [ket(1)_A ket(0)_B + ket(0)_A ket(1)_B] = ket(Phi_X) \
  10 & -> "act with" Y                & -> 1/sqrt(2) [ket(1)_A ket(0)_B - ket(0)_A ket(1)_B] = ket(Phi_Y) \
  11 & -> "act with" Z                & -> 1/sqrt(2) [ket(0)_A ket(0)_B - ket(1)_A ket(1)_B] = ket(Phi_Z)
$

Alice then sends her qubit. Now Bob has a 2 qubits in 1 of 4 possible orthonormal states, and all he needs to do is measure with a 2-qubit operator that has $ket(Phi_I)$, $ket(Phi_X)$, $ket(Phi_Y)$ and $ket(Phi_Z)$ as its eigenstates. The eigenvalue he gets from that will tell him _with certainty_ which message Alice sent.

Alice just managed to send 2 bits by sending 1 qubit! This coding is known as *super-dense coding*.

== Cloning

All this talk of teleportation and quantum computation is making me think of sci-fi, and sci-fi makes me think of cloning. Is cloning possible? And is it a good idea? Well I can't answer the second question, but I can try answering the first.

We can prove this by pretending that we have a quantum operator $C$ that does cloning. That means that if we apply $C$ to a pair of qubits, it should copy the first qubit into the second:

$
  C ket(psi) ket(Omega) = ket(psi) ket(psi)
$

We want this operator to be universal, so $ket(psi)$ should be allowed to be any state. Now let's say we have a superposition state $(ket(psi) + ket(phi))$. This should be no problem for our cloning operator:

$
  C (ket(psi) + ket(phi)) ket(Omega) = (ket(psi) + ket(phi)) (ket(psi) + ket(phi))
$

But wait a minute, since quantum operators are linear, we can expand those brackets out on the left hand side:

$
  C ket(psi) ket(Omega) + C ket(phi) ket(Omega) = ket(psi) ket(psi) + ket(phi) ket(phi)
$

That's a contradiction! That's not what we wanted, our perfect little cloning operator doesn't work!

Reality is often disappointing. So cloning is not allowed, as specified by the aptly-named *no-cloning theorem*. I guess we won't have to answer that second question after all.

#note(title: [Dolly the sheep])[
  You're probably thinking: what about Dolly the sheep? I read in the news that she was the first cloned animal, and yet you're here telling me that cloning isn't even real?

  Both things are true, they just have different versions of "cloning". There's nothing stopping you from cloning a cell, so long as the particles that make up that cell are different. The no-cloning theorem doesn't really apply for anything except quantum states. You can make a copy of every cell in your body, but it won't be a 100% atom-for-atom clone of you, which who knows what kinds of consequences that could end up having.
]

== CHSH game

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

$
  a plus.o b = x y
$

where the rules of $plus.o$ (addition modulo 2) are:

$
  0 plus.o 0 & = 0 \
  0 plus.o 1 & = 1 \
  1 plus.o 0 & = 1 \
  1 plus.o 1 & = 0 \
$

It's basically an `XOR`.

These are the 4 cases above:

- Neither Carol nor Dan show up, meet up at same place: $a_0 plus.o b_0 = 0 times 0 = 0$, meaning $a_0 = b_0$.
- Carol shows up but not Dan, meet up at the same place: $a_1 plus.o b_0 = 1 times 0 = 0$, meaning $a_1 = b_0$.
- Dan shows up but not Carol, meet up at the same place: $a_0 plus.o b_1 = 0 times 1 = 0$, meaning $a_0 = b_1$.
- Both Carol and Dan show up, meet at different places: $a_1 plus.o b_1 = 1 times 1 = 1$, meaning $a_1 != b_1$.

where

- $a_0$ is Alice's response when Carol doesn't show up ($x=0$)
- $a_1$ is Alice's response when Carol does show up ($x=1$)
- $b_0$ is Bob's response when Dan doesn't show up ($y=0$)
- $b_1$ is Bob's response when Dan does show up ($y=1$)

To prove that we can't win the game 100% of the time using any classical strategy, we can prove that there's no combination of values for $a_0$, $a_1$, $b_0$ and $b_1$ that work. To do that, we can simply add them up (modulo 2):

$
  (a_0 plus.o b_0) plus.o (a_1 plus.o b_0) plus.o (a_0 plus.o b_1) plus.o (a_1 plus.o b_1) & = 0 plus.o 0 plus.o 0 plus.o 1 \
  (a_0 plus.o a_0) plus.o (a_1 plus.o a_1) plus.o (b_0 plus.o b_0) plus.o (b_1 plus.o b_1) & = 1 \
  0 plus.o 0 plus.o 0 plus.o 0 & = 1 \
  0 & = 1
$

Here, we used the rule that $n plus.o n = 0$, as we saw in the modulo 2 rules above. We ended up with the result $0 = 1$, which we know for a fact is nonsensical, and we didn't even assign any values to $a_0$, $a_1$, $b_0$ or $b_1$!

So that means that there don't exist any values where you can get 100% success, meaning out of our 4 equations at least one must not be satisfied, giving us an upper bound of 3/4 or 75% success, which we alreadya

Now let's use the power of quantum entanglement to pump up those numbers!

As usual, we start with Alice and Bob sharing the maximally entangled state:

$
  ket(Phi) = (ket(0) ket(0) + ket(1) ket(1))/sqrt(2)
$

If Carol shows up, Alice measures her qubit with operator $A_1$, otherwise she uses $A_0$. Similarly, Bob uses $B_1$ on his qubit if Dan shows up, and $B_0$ otherwise. $A_0$, $A_1$, $B_0$ and $B_1$ all have eigenvalues $+1$ and $-1$, so to produce their answers $a$ and $b$, they use:

$
  a & = cases(
        0 "if" alpha = +1,
        1 "if" alpha = -1,
      ) \
  b & = cases(
        0 "if" beta = +1,
        1 "if" beta = -1,
      )
$

where $alpha$ and $beta$ are the eigenvalues that Alice and Bob get from measuring their respective operator on their respective qubit.

The operators that Alice and Bob use are:

$
  A_0 & = X \
  A_1 & = Z \
  B_0 & = (X + Z)/sqrt(2) \
  B_1 & = (X - Z)/sqrt(2)
$

The thing we're actually measuring is the outcome after both Alice and Bob apply their operators:

$
  braket(Phi, A times.o B, Phi) & = sum_(alpha, beta) alpha beta Pr(alpha, beta) \
  & = Pr(alpha=+1, beta=+1) - Pr(alpha=+1, beta=-1) - Pr(alpha=-1, beta=+1) + Pr(alpha=-1, beta=-1) \
  & = Pr(alpha = beta) - Pr(alpha != beta) \
  & = Pr(alpha = beta) - (1 - Pr(alpha = beta)) \
  & = 2 Pr(alpha = beta) - 1
$

which we can rearrange to get:

$
  Pr(alpha = beta) = (1 + braket(Phi, A times.o B, Phi))/2
$

#note(title: [Expectation value])[
  The statement $braket(Phi, A times.o B, Phi) = sum_(alpha, beta) alpha beta Pr(alpha, beta)$ comes from the fact that measurement of a quantum system is equivalent to finding the expectation value. It holds true for any state and pair of operators $A$ and $B$ with eigenvalues $plus.minus 1$, not just the particular ones we've chosen here.
]

Since both Alice and Bob decide to give the answer $0$ when their respective measurement outcome is $+1$, and $1$ when their respective measurement outcome is $-1$, we know that when $alpha = beta$, $a = b$. This means that we can rewrite that expression as

$
  Pr(a plus.o b = 0 | x, y) = (1 + braket(Phi, A times.o B, Phi))/2
$

and by using $Pr(alpha = beta) + Pr(alpha != beta) = 1$:

$
  Pr(a plus.o b = 1 | x, y) & = 1 - (1 + braket(Phi, A times.o B, Phi))/2 \
                            & = (1 - braket(Phi, A times.o B, Phi))/2
$

Now we just have to find the values of $braket(Phi, A times.o B, Phi)$. This calculation is going to be tedious if we try to do it manually, so let's try and simplify things a bit. Looking at our 4 operators, we can notice that they're basically the same operator with an angle on the $X$-$Z$ plane:

$
  S(theta) & = cos(theta) X + sin(theta) Z \
      S(0) & = cos(0) X + sin(0) Z = X \
   S(pi/4) & = cos(pi/4) X + sin(pi/4) Z = (X + Z)/sqrt(2) \
   S(pi/2) & = cos(pi/2) X + sin(pi/2) Z = Z \
  S(-pi/4) & = cos(-pi/4) X + sin(-pi/4) Z = (X - Z)/sqrt(2) \
$

We can use this more general formula to simplify our expression, and since we know that our 4 operators are just special cases of this more general operator, we can plug in our angles for those later.

$
  braket(Phi, S(theta) times.o S(phi), Phi) & = && braket(Phi, (cos(theta) X + sin(theta) Z) times.o (cos(phi) X + sin(phi) Z), Phi) \
  & = && cos(theta) cos(phi) braket(Phi, X times.o X, Phi) \
  & && + cos(theta) sin(phi) braket(Phi, X times.o Z, Phi) \
  & && + sin(theta) cos(phi) braket(Phi, Z times.o X, Phi) \
  & && + sin(theta) sin(phi) braket(Phi, Z times.o Z, Phi) \
$

We can simplify this a bit, knowing that $X times.o X ket(Phi) = Z times.o Z ket(Phi) = ket(Phi)$:

$
  (X times.o X) (ket(0) ket(0) + ket(1) ket(1))/sqrt(2) & = (ket(1) ket(1) + ket(0) ket(0))/sqrt(2) \
                                                        & = ket(Phi) \
  (Z times.o Z) (ket(0) ket(0) + ket(1) ket(1))/sqrt(2) & = (ket(0) ket(0) + (-1)(-1) ket(1) ket(1))/sqrt(2) \
                                                        & = (ket(0) ket(0) + ket(1) ket(1))/sqrt(2) \
                                                        & = ket(Phi)
$

Similarly, we have $X times.o Z ket(Phi) = ket(Psi)$ and $Z times.o X ket(Phi) = -ket(Psi)$:

$
  (X times.o Z) (ket(0) ket(0) + ket(1) ket(1))/sqrt(2) & = (ket(1) ket(0) - ket(0) ket(1))/sqrt(2) \
                                                        & = ket(Psi) \
  (Z times.o X) (ket(0) ket(0) + ket(1) ket(1))/sqrt(2) & = (ket(0) ket(1) - ket(1) ket(0))/sqrt(2) \
                                                        & = -ket(Psi)
$

where $braket(Psi, Phi) = braket(Phi, Psi) = 0$, i.e. $ket(Phi)$ and $ket(Psi)$ are orthogonal.

Simplifying:

$
  braket(Phi, S(theta) times.o S(phi), Phi) & = && cos(theta) cos(phi) braket(Phi, X times.o X, Phi) \
                                            &   && + cos(theta) sin(phi) braket(Phi, X times.o Z, Phi) \
                                            &   && + sin(theta) cos(phi) braket(Phi, Z times.o X, Phi) \
                                            &   && + sin(theta) sin(phi) braket(Phi, Z times.o Z, Phi) \
                                            & = && cos(theta) cos(phi) braket(Phi, Phi) \
                                            &   && + cos(theta) sin(phi) braket(Phi, Psi) \
                                            &   && - sin(theta) cos(phi) braket(Phi, Psi) \
                                            &   && + sin(theta) sin(phi) braket(Phi, Phi) \
                                            & = && cos(theta) cos(phi) + sin(theta) sin(phi) \
                                            & = && cos(theta - phi)
$

That last step comes from the trigonometry rule:

$
  cos(a + b) & = cos(a) cos(b) - sin(a) sin(b) \
  cos(a - b) & = cos(a) cos(-b) - sin(a) sin(-b) \
             & = cos(a) cos(b) + sin(a) sin(b)
$

since $cos(-x) = cos(x)$ and $sin(-x) = -sin(x)$

Let's plug this back in to our original formula:

$
  Pr(a plus.o b = 0 | x, y) & = (1 + braket(Phi, S(theta) times.o S(phi), Phi))/2 \
                            & = (1 + cos(theta - phi) braket(Phi, Phi))/2 \
                            & = (1 + cos(theta - phi))/2
$

That's much better! We can plug in our operator angles and check each case:

$
  Pr(a plus.o b = 0 | x=0, y=0) & = (1 + cos(0 - pi/4))/2 \
                                & = (1 + cos(-pi/4))/2 \
                                & approx 0.854 \
  Pr(a plus.o b = 0 | x=0, y=1) & = (1 + cos(0 - (-pi/4)))/2 \
                                & = (1 + cos(pi/4))/2 \
                                & approx 0.854 \
  Pr(a plus.o b = 0 | x=1, y=0) & = (1 + cos(pi/2 - pi/4))/2 \
                                & = (1 + cos(pi/4))/2 \
                                & approx 0.854 \
$

For the $x=1, y=1$ case, when both Carol and Dan show up, we want Alice and Bob to go to different places, meaning $a plus.o b = 1$:

$
  Pr(a plus.o b = 1 | x=1, y=1) & = (1 - cos(pi/2 - (-pi/4)))/2 \
                                & = (1 - cos(3pi/4))/2 \
                                & approx 0.854 \
$

So we see that using this quantum strategy, Alice and Bob can *succeed approximately 85.4%* of the time! We just proved that a quantum strategy is significantly better than any classical strategy we could have found!

Whew, that's a lot of math! If you made it through all that, congratulations! If you just scrolled past it all and skipped to this point, I don't blame you.

#note(title: [CHSH])[
  "CHSH" stands for Clauser, Horne, Shimony and Holt. They presented a simpler and more powerful version of #link("https://en.wikipedia.org/wiki/Bell's_theorem")[Bell's theorem] about quantum nonlocality. The version presented here is the more modern framing in the form of a game. That's how it was first taught to me, though with a lot more math (if you can believe it) and a lot of details that I decided to skip here.
]

= Conclusion

I think I'll wrap it up there for now. There are a _lot_ of other things left that I could have covered, like Grover's algorithm, Shor's algorithm, quantum circuits, quantum cryptography, etc., but this post is more than long enough already, and I think most of you have probably left by now after seeing that wall of math. Maybe I'll end up writing about those things in the future.

I'm not sure if you can tell, but this kind of stuff really excites me. We have _mathematical proof_ that quantum computers are capable of doing things that classical computers aren't, and all of it is based entirely upon _linear algebra and complex numbers_! And that's just scratching the surface of what's possible!

I'd also like to mention #link("https://codeberg.org/noClaps/qcsim")[QCSim], a quantum computer simulator I built. Most of the stuff I've talked about in this post were what inspired me to build this, and in turn inspired me to look into quantum information and quantum computation as a career path in the first place.

Anyway, that's all I've got for now, seeya next time (hopefully sooner than 5 months lol)!
