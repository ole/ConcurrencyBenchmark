import CollectionsBenchmark
import Computation
import Dispatch

let totalWorkload = 10_000_000

@main
struct Main {
  static func main() {
    var benchmark = Benchmark(title: "Fibonacci")

    benchmark.addSimple(title: "No parallelism (1 core)", input: Int.self) { input in
      blackHole(performWork_syncSingleCore(taskCount: input))
    }
    benchmark.addSimple(title: "concurrentPerform", input: Int.self) { input in
      blackHole(performWork_concurrentPerform(taskCount: input))
    }

    benchmark.addSimple(title: "DispatchQueue.global().async", input: Int.self) { input in
      blackHole(performWork_dispatchQueueGlobalAsync(taskCount: input))
    }

    benchmark.addSimple(title: "TaskGroup", input: Int.self) { input in
      blackHole(performWork_taskGroup(taskCount: input))
    }

    benchmark.main()
  }
}

/// - Parameter taskCount: The number of "subtasks" the workload should be split into.
///   The total amount of work remains constant, regardless of input.
func performWork_syncSingleCore(taskCount: Int) {
  for _ in 0 ..< taskCount {
    _ = fibonacciOverflow(totalWorkload / taskCount)
  }
}

/// - Parameter taskCount: The number of "subtasks" the workload should be split into.
///   The total amount of work remains constant, regardless of input.
func performWork_concurrentPerform(taskCount: Int) {
  DispatchQueue.concurrentPerform(iterations: taskCount) { i in
    _ = fibonacciOverflow(totalWorkload / taskCount)
  }
}

/// - Parameter taskCount: The number of "subtasks" the workload should be split into.
///   The total amount of work remains constant, regardless of input.
func performWork_dispatchQueueGlobalAsync(taskCount: Int) {
  let dispatchGroup = DispatchGroup()
  for _ in 0 ..< taskCount {
    DispatchQueue.global().async(group: dispatchGroup) {
      _ = fibonacciOverflow(totalWorkload / taskCount)
    }
  }
  dispatchGroup.wait()
}

/// - Parameter taskCount: The number of "subtasks" the workload should be split into.
///   The total amount of work remains constant, regardless of input.
func performWork_taskGroup(taskCount: Int) {
  let dispatchGroup = DispatchGroup()
  dispatchGroup.enter()

  let work = _Concurrency.Task.detached {
    await withTaskGroup(of: Void.self) { group in
      for _ in 0 ..< taskCount {
        group.addTask {
          _ = fibonacciOverflow(totalWorkload / taskCount)
        }
      }
      for await _ in group {}
    }
  }

  // Wait for async work from sync context.
  _Concurrency.Task.detached {
    _ = await work.value
    dispatchGroup.leave()
  }
  dispatchGroup.wait()
}
