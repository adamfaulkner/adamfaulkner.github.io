---
title: "Serialization Bakeoff"
date: 2025-03-13T12:21:55-07:00
draft: true
# bookComments: false
# bookSearchExclude: false
---

# TL;DR

- Existing comparisons between serialization formats often ignore browsers or make other incorrect assumptions. I've run an experiment that attempts to address some common issues.
- Bebop is a serialization format that I hadn't heard of before, but it's all around really fast and easy to use.
- Flatbuffers are really fast, but hard to use.
- Cap'n Proto is all around not great.
- The performance of Protobuf, MessagePack and CBOR are rather lackluster.

# Introduction: Why do we need Another Serialization Format Benchmark?

Some prior art:
- [JavaScript Serialization Benchmark](https://github.com/Adelost/javascript-serialization-benchmark)
- [Rust Serialization Benchmark](https://github.com/djkoloski/rust_serialization_benchmark). This only focuses on Rust, and includes a number of formats that don't have implementations in other languages.
- [Benchmarking Eight Serialization Formats in C and C++](https://www.reddit.com/r/cpp/comments/1drz3eg/benchmarking_eight_serialization_formats_in_c_and/). This reddit post focuses on schemaless serialization formats.
- [.NET Serialization Benchmarks](https://github.com/ProgrammerAl/SerializationBenchmarks)

## JavaScript

None of these consider JavaScript. This is unfortunate because browsers are widely used and JavaScript has different characteristics due to its use of a JIT. In many cases, JSON ends up being a more efficient format than others due to its close integration with the runtime.

## Compression

Applying compression to serialized messages can significantly reduce their size, at the cost of increased CPU utilization. If excess CPU is available, and compression is pipelined, this may not significantly increase latency.

## Non-representative data sets

The JavaScript Serialization Benchmark above mostly focused on serializing integers and floating point numbers, which is one area where binary formats tend to always outperform JSON. This gives an advantage to serialization formats that can handle these efficiently, and does not give us much information about the performance when working with other data types.

Additionally, generating data programmatically can create datasets that do not behave realistically under compression.

To address these concerns, I've used the NYC Citibike Dataset, which features a number of different data types, and should be reasonably compressible as it is a real world dataset.

## Focus on Schemaless Formats


# Formats tested,

## JSON

##
