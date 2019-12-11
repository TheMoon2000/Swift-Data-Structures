# Data Structures for Swift
This project aims to provide a variety of enhancements (both features and performance) to the existing data structures in Swift. Thep purpose of these improvements is to let Swift become more powerful in computations.

### Array Operations
This category of improvements are extensions to the existing Swift arrays. Many of these are inspired by the NumPy library for python.

- Example computations for floating types

  ```swift
    // Scalar arithmetics with vectors
    let A: [Double] = [0.3, -2.5, 4.0, 1.2] // Create a Double array
    print(A * 2, A + 2) // [0.6, -5.0, 8.0, 2.4] [2.3, -0.5, 6.0, 3.2]
    print(A / 2, A - 2) // A / 2 = [0.15, -1.25, 2.0, 0.6] [-1.7, -4.5, 2.0, -0.8]
    print(A.sum, A.mean) // 3.0 0.75
    print(A.variance, A.std) // 5.3825 2.32001...
    print(A.abs, A.sqrt) // [0.3, 2.5, 4.0, 1.2] [0.5477..., -nan, 2.0, 1.0954...]
    print(A.diff()) // [-2.8, 6.5, -2.8]

    // Vector arithmetics
    let B = [1.0, 2.0, 3.0, 4.0] // Create another double array
    let C = [4.0, 2.0] // Will be used as an example of unaligned vector operations
    print(A • B, A * B) // Two equivalent ways to compute the dot product [0.3, -5.0, 12.0, 4.8]
    print(A + B) // [1.3, -0.5, 7.0, 5.2]
    print(A + C) // [4.3, -0.5, 4.0, 1.2] (the shorter array is treated as having trailing zeroes)
    print(A * C, A / C) // [1.2, -5.0, 0.0, 0.0] [0.075, -1.25, 0.0, 0.0] (unaligned portion treated as zero for * and /)

    // Comparisons
    print(A <= 1.2, A == 4.0) // [true, true, false, true] [false, false, true, false]

    // Note: Unaligned vector comparisons are supported. They will be aligned from index 0, and the unaligned portion will always return `false`.
    print(A > [0.5, 0.5, 0.8]) // [false, false, true, false]
    print([0.0, -3.0, 5.0, 2.0] <= A) // [true, true, false, false]
  ```

- Integer types

  ```swift
  let I: [Int] = [-3, 5, 9, -2, 17] // Create an Int array
  print(I * 2, I + 2) // [-6, 10, 18, -4, 34] [-1, 7, 11, 0, 19]
  print(I / 2, I - 2) // [-1, 2, 4, -1, 8], [-5, 3, 7, -4, 15]
  print(I << 2, I >> 2) // [-12, 20, 36, -8, 68] [-1, 1, 2, -1, 4]
  print(I.diff()) // [8, 4, -11, 19]

  // Int comparisons are essentially the same as floating point comparisons. See above for examples.
  ```

Some of the speedup improvements are rather significant. For example, consider ways in which one can compute the sum of an array of numbers. Traditionally, we could use `reduce()` (which should be faster than a manual for loop). Below is a timing comparison of `reduce()` versus `Array<Double>.sum()`:

```swift

let randomDoubles = (0..<(1 << 24)).map { _ in Double.random(in: -100...100) }

let reduceStart = Date.timeIntervalSinceReferenceDate
let manualSum: Double = randomDoubles.reduce(0.0, { result, next in
    return result + next
})
let reduceEnd = Date.timeIntervalSinceReferenceDate
print("Reduce: \(reduceEnd - reduceStart)s") // Reduce: 5.002105951309204s

let simdStart = Date.timeIntervalSinceReferenceDate
let simdSum = randomDoubles.sum()
let simdEnd = Date.timeIntervalSinceReferenceDate
print("SIMD: \(simdEnd - simdStart)s") // SIMD: 1.1132100820541382s
```

There is roughly a 4.5x speedup on my 2-core machine. If your machine has more cores, it should be even faster. Here's another example of speed comparison on vector addition:

```swift
let randomDoubles1 = (0..<(1 << 23)).map { _ in Double.random(in: -100...100) }
let randomDoubles2 = (0..<(1 << 23)).map { _ in Double.random(in: -100...100) }

let vanillaStart = Date.timeIntervalSinceReferenceDate
var vanillaResult = [Double](repeating: 0.0, count: randomDoubles1.count)
for i in 0..<randomDoubles1.count {
   vanillaResult[i] = randomDoubles1[i] + randomDoubles2[i]
}
let vanillaEnd = Date.timeIntervalSinceReferenceDate
print("Vanilla: \(vanillaEnd - vanillaStart)s") // Vanilla: 5.47455096244812s

let simdStart = Date.timeIntervalSinceReferenceDate
let simdResult = randomDoubles1 ++ randomDoubles2
let simdEnd = Date.timeIntervalSinceReferenceDate
print("SIMD: \(simdEnd - simdStart)s") // SIMD: 1.2500649690628052s
```

All the outputs were real outputs I I pasted from my computer.

Scalar multiplication is one of those operations that did not receive much speedup. I have taken sampled data on this operation for 5 different approaches, and plotted their efficiency. It's interesting to see that Swift's built-in map function is faster relative to a vanilla for loop, despite slower than any of the SIMD algorithms because it's serial. <br />

  <img src="Screenshots/DoubleArrayPerformance.jpg" width="90%" />
  <img src="Screenshots/DoubleArraySpeedup.jpg" width="90%" />

  Eventually I chose to use vectors of size 32 because it yields the best asymptotic performance from my experiments. I also used this vector size for the other array operations.

### Numeric Data structures
- Complex numbers (`Complex`)
