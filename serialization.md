# A Comparison of Serialization Techniques Between a Server and a Browser

## Intro

Most browser apps use JSON encoding to send data between the server and the browser. JSON is known to not be especially efficient on the server side -- see [these Go serialization benchmarks](https://alecthomas.github.io/go_serialization_benchmarks/) or [these Rust serialization benchmarks](https://david.kolo.ski/rust_serialization_benchmark/). However, in my experience, JSON works better than other options in JavaScript, likely due to its close integration with the underlying JavaScript engine.

I was curious about understanding this better, so I wrote some benchmarks to compare several different options. I found that JSON is usually fastest on the client side when the serialized data is limited to JSON's supported types, but that other options work better for many use cases.

## The Formats I Tested, Their Strengths, and Their Weaknesses

### JSON

JSON has a number of strengths:

* It is directly supported by the JavaScript runtime, no libraries are required.
* Serialized JSON is somewhat human readable without needing additional tools.
* In my tests, JSON performed very well on "deserialization" without additional verification or type conversions. For data that fits within the types supported by JSON, it is likely the fastest option on the client side. 

However, JSON has many weaknesses when compared to alternative formats:

#### Limited Type Support
JSON does not support many types that are important for many types of programs. For example, JSON does not have a 64 bit integer type. Some implementations will use a 64 bit floating point type for these values, which will silently mangle values greater than or equal to 2 to the 53rd power. The workaround for this is typically to represent these values using strings, which can be parsed into a BigInt value, or just kept in a string representation if numeric operations will not be performed on these values.

As another example, JSON does not have a native "date" type, which means that the programmer will be responsible for manually constructing a `Date` from either a number or a string received in JSON.


#### Schemaless

The second weakness in JSON is that it is a "schemaless" format, so we must either trust the source of the data, or we must validate it ourselves when we receive it. This can be expensive, and it's important when comparing serialization formats to consider which formats contain these kinds of guardrails "for free".

(Some might argue that the "schemaless" nature of JSON is a feature. However, all large programs that I've worked on eventually end up with static types and schemas defined for the JSON that get passed around, so I'd argue that JSON's schemalessness is not a helpful property.)

##### Digression: Javascript Object Validation Libraries

Zod is a library that can be used to perform this validation, but it's rather slow. As part of this study, I tested out Zod and another library called Ajv. Ajv was pretty darn fast, but could not verify anything outside of JSON's types. For my benchmark, that was good enough. In a real project, I would probably research other alternatives and try to find a library that both performs well and supports a wider range of types.

#### Large Serialized Message Size

JSON produces very large messages, which consumes additional network bandwidth. This can be mostly mitigated by compressing these messages with Zstd, however, this costs additional CPU time on the server side that other formats do not need to pay to achieve similar results.

#### Required String Input

`JSON.parse` requires a string as input. This can be problematic with large inputs, as [some JavaScript implementations cap the length of a string at 512MB (nodejs) or 1GB (Chrome)](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/length).

#### Poor Performance on the Server Side

In my benchmarks, using a Rust server, JSON serialization was slower han most alternatives.
  
### Protobuf

Protobuf solves many of the above weaknesses in JSON. When compared with the other serialization formats that I tested, Protobuf's main advantage is that it is ubiquitous and well understood, and it has good tooling. For example, there's a simple command line tool for printing out an encoded protobuf message in a human readable format.

Protobuf's main disadvantage in the browser is performance, as it performs worse than Bebop. It also lacks native support for dates, instead relying on an official extension type. This extension type can encode dates with nanosecond precision, but it is rather expensive to encode and decode, so I stuck with expressing dates as milliseconds since the epoch for my tests.
 
### Bebop

Bebop was the biggest surprise of the formats that I tested. It outperformed everything, it natively supports `Date`s in JavaScript, and it had easy to use tooling. The main weakness that I see with it is that it seems relatively new and not widely adopted, which makes adopting it somewhat more risky.

### Avro

Avro produced the smallest messages of any format that I tested. However, it did not perform well compared to JSON and Bebop. Its tooling was also slightly inferior -- the library I used, `avsc`, did not feature any support for generating TypeScript types from Avro schemas. There are third party libraries that could fill this gap, however.

Aiyah

### Flatbuffers

### The Bad Ones

####  Capnp
Capnp seems to have bitrotted in the past few years, as it was difficult to find a library that worked. In the end, I used [capnp-es](https://github.com/unjs/capnp-es) since I could not get [capnp-ts](https://github.com/jdiaz5513/capnp-ts) to compile without errors.

Capnp performed extremely poorly, to the point where I needed to exclude it from my benchmarking to be able to make progress on other formats.

#### Msgpack / Cbor

I've grouped msgpack and cbor together because they behaved pretty similarly in my comparison.

Both of these have some positives in that they support more types than JSON, and they are schemaless, so they are more likely to work as a drop-in replacement for JSON.

However, their serialized messages were extremely large, and their performance was not very good, which makes them seem worse than alternatives.

## The Data

### Message Size

### Serialization Time on the Server



## Where Other Benchmarks Fall Short, and Shortcomings of my Approach


