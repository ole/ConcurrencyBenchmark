# ConcurrencyBenchmark

Benchmarks for CPU-bound computation comparing different parallelization strategies.

## Usage

Run the benchmarks:

```sh
swift run -c release benchmark run \
  --cycles 3 \
  --min-size 10 \
  --max-size 256k \
  BenchmarkData/benchmark-data.json
```

Create a chart:

```sh
swift run -c release benchmark render \
  BenchmarkData/benchmark-data.json \
  BenchmarkData/chart.png \
  --amortized false \
  && open BenchmarkData/chart.png
```

For more options:
- See the [Swift Collections Benchmark Getting Started Guide](https://github.com/apple/swift-collections-benchmark/blob/main/Documentation/01%20Getting%20Started.md)
- `swift run -c release benchmark run --help`
- `swift run -c release benchmark render --help`

## Current chart

![Current chart](BenchmarkData/chart.png)
