# Benchmarking Binary Encoding Libraries in a Browser is Really Hard

# WIP:

Maybe try to use this comment: https://news.ycombinator.com/item?id=33407745

This is just outright wrong: https://github.com/protobufjs/protobuf.js#performance

## TL;DR

I spent huge amounts of time trying to determine whether any binary encodings outperform JSON in a browser. Doing this benchmarking was harder than anticipated. In the end, I determined the unreleased version (as of this writing) of [avsc](https://github.com/mtth/avsc) is faster than JSON in browsers.

In this post, I summarize several reasons why it was so difficult to get this result, and suggest some techniques for doing this kind of analysis in the future.

## Why not JSON?

JSON has a number of strengths:

* It is directly supported by the JavaScript runtime, no libraries are required.
* Serialized JSON is somewhat human readable without needing additional tools.
* In my tests, JSON performed very well on "deserialization" without additional verification or type conversions. For data that fits within the types supported by JSON, it is likely the fastest option on the client side. 

However, JSON has many weaknesses when compared to alternative formats:

### Limited Type Support
JSON does not support many types that are important for many types of programs. For example, JSON does not have a 64 bit integer type. Some implementations will use a 64 bit floating point type for these values, which will silently mangle values greater than or equal to 2 to the 53rd power. The workaround for this is typically to represent these values using strings, which can be parsed into a BigInt value, or just kept in a string representation if numeric operations will not be performed on these values.

As another example, JSON does not have a native "date" type, which means that the programmer will be responsible for manually constructing a `Date` from either a number or a string received in JSON.


### Limited Validation

Decoding JSON performs no validation on the shape or type of the decoded data. If we want these sorts of validations, we must validate messages ourselves when we receive them.

When sending data from a server to a web browser, even though we may trust the server, it can still be useful to do this sort of validation to avoid confusing bugs. It's quite common to have version skew bugs between different versions of the client and server; detecting these up front by validating the shape of received messages can avoid confusing bugs.


Many serialization formats, like Protobuf, perform this sort of validation implicitly when deserializing messages. Since this validation can be expensive, it's important when comparing serialization formats to consider which formats contain these kinds of guardrails "for free". This is something that many existing benchmarks get wrong.

(Some might argue that the "schemaless" nature of JSON is a feature. However, all large programs that I've worked on eventually end up with static types and schemas defined for the JSON that get passed around, so I'd argue that JSON's schemalessness is not a helpful property.)

#### Digression: Javascript Object Validation Libraries

When doing this work, I looked at a handful of libraries in JavaScript for validating that an object matches a particular schema.

One such library is called "Zod". Zod was extremely slow, so it felt unfair to rely on it when doing comparisons. I found another library called Ajv, which was pretty darn fast, but could not verify anything outside of JSON's types. For my benchmark, that was good enough. In a real project, I would probably research other alternatives and try to find a library that both performs well and supports a wider range of types.

### Large Serialized Message Size

JSON produces very large messages, which consumes additional network bandwidth. This can be mostly mitigated by compressing these messages with Zstd, however, this costs additional CPU time on the server side that other formats do not need to pay to achieve similar results.

### Required String Input

`JSON.parse` requires a string as input. This can be problematic with large inputs, as [some JavaScript implementations cap the length of a string at 512MB (nodejs) or 1GB (Chrome)](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/length).

### Poor Performance on the Server Side

In my benchmarks, using a Rust server, JSON serialization was slower han most alternatives.
