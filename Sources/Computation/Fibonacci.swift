public func fibonacciOverflow(_ n: Int) -> Int {
  var a = 0
  var b = 1
  for _ in 0 ..< n {
    let tmp = b
    b = a &+ b
    a = tmp
  }
  return a
}
