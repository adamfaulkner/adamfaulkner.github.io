<head>
    <title> Serialization From NodeJS </title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script type="text/javascript">
    // Final Serialize Duration
    // Serializer	Avg (ms)
    // ------------------------
    // json      	1440.67
    // msgpack   	713.00
    // cbor      	716.65
    // proto     	5532.67
    // avro      	586.67
    // bebop     	2700.67
    // flatbuffers	3723.00
    // pbf       	563.33
    //
    // Unoptimized Serializer Duration
    // Serializer	Avg (ms)
    // ------------------------
    // json      	1415.33
    // msgpack   	910.67
    // cbor      	1335.67
    // proto     	5582.33
    // avro      	5443.33
    // bebop     	12351.00
    // flatbuffers	3674.00
    const serializationStats = [
      {"name":"json","rustSerializeDuration":458, "finalSerializeDuration": 1440.67, "unoptimizedSerializeDuration": 1415.33 },
      {"name":"protobuf.js","rustSerializeDuration":281, "finalSerializeDuration": 5532.67, "unoptimizedSerializeDuration": 5582.33 },
      {"name":"pbf","rustSerializeDuration":281, "finalSerializeDuration": 563.33, "unoptimizedSerializeDuration": 563.33 },
      {"name":"msgpack","rustSerializeDuration":287, "finalSerializeDuration": 713.00, "unoptimizedSerializeDuration": 910.67 },
      {"name":"cbor","rustSerializeDuration":331, "finalSerializeDuration": 716.65, "unoptimizedSerializeDuration": 1335.67 },
      {"name":"bebop","rustSerializeDuration":190, "finalSerializeDuration": 2700.67, "unoptimizedSerializeDuration": 12351.00 },
      {"name":"avro","rustSerializeDuration":321, "finalSerializeDuration": 586.67, "unoptimizedSerializeDuration": 5443.33 },
    ];
    function createFinalResultsChart() {
      const ctx = document.getElementById('finalResultsChart').getContext('2d');
      const sortedStats = [...serializationStats].sort((a, b) => a.finalSerializeDuration - b.finalSerializeDuration);
      new Chart(ctx, {
        type: 'bar',
        data: {
          labels: sortedStats.map(stat => stat.name),
          datasets: [{
            label: 'Final Serialization Duration (ms)',
            data: sortedStats.map(stat => stat.finalSerializeDuration),
            backgroundColor: 'rgba(54, 162, 235, 0.8)',
            borderColor: 'rgba(54, 162, 235, 1)',
            borderWidth: 1
          }]
        },
        options: {
          responsive: true,
          scales: {
            y: {
              beginAtZero: true,
              title: {
                display: true,
                text: 'Duration (ms)'
              }
            }
          },
          plugins: {
            title: {
              display: true,
              text: 'Final Serialization Performance Comparison'
            }
          }
        }
      });
    }
    function createPreOptimizationChart() {
      const ctx = document.getElementById('preOptimizationChart').getContext('2d');
      const formats = ['msgpack', 'cbor', 'bebop', 'avro'];
      const filteredStats = serializationStats.filter(stat => formats.includes(stat.name));
      new Chart(ctx, {
        type: 'bar',
        data: {
          labels: filteredStats.map(stat => stat.name),
          datasets: [{
            label: 'Unoptimized Duration (ms)',
            data: filteredStats.map(stat => stat.unoptimizedSerializeDuration),
            backgroundColor: 'rgba(255, 99, 132, 0.8)',
            borderColor: 'rgba(255, 99, 132, 1)',
            borderWidth: 1
          }, {
            label: 'Final Optimized Duration (ms)',
            data: filteredStats.map(stat => stat.finalSerializeDuration),
            backgroundColor: 'rgba(75, 192, 192, 0.8)',
            borderColor: 'rgba(75, 192, 192, 1)',
            borderWidth: 1
          }]
        },
        options: {
          responsive: true,
          scales: {
            y: {
              beginAtZero: true,
              title: {
                display: true,
                text: 'Duration (ms)'
              }
            }
          },
          plugins: {
            title: {
              display: true,
              text: 'Pre-Optimization vs Post-Optimization Comparison'
            }
          }
        }
      });
    }
    function createBebopChart() {
      const ctx = document.getElementById('bebopChart').getContext('2d');
      const bebopStat = serializationStats.find(stat => stat.name === 'bebop');
      const jsonStat = serializationStats.find(stat => stat.name === 'json');
      new Chart(ctx, {
        type: 'bar',
        data: {
          labels: ['Bebop Pre-Optimize', 'Bebop Optimized', 'JSON'],
          datasets: [{
            label: 'Serialization Duration (ms)',
            data: [bebopStat.unoptimizedSerializeDuration, bebopStat.finalSerializeDuration, jsonStat.finalSerializeDuration],
            backgroundColor: [
              'rgba(255, 99, 132, 0.8)',
              'rgba(75, 192, 192, 0.8)',
              'rgba(255, 206, 86, 0.8)'
            ],
            borderColor: [
              'rgba(255, 99, 132, 1)',
              'rgba(75, 192, 192, 1)',
              'rgba(255, 206, 86, 1)'
            ],
            borderWidth: 1
          }]
        },
        options: {
          responsive: true,
          scales: {
            y: {
              beginAtZero: true,
              title: {
                display: true,
                text: 'Duration (ms)'
              }
            }
          },
          plugins: {
            title: {
              display: true,
              text: 'Bebop Performance: Pre-Optimize vs Optimized vs JSON'
            }
          }
        }
      });
    }
    function createProtobufChart() {
      const ctx = document.getElementById('protobufChart').getContext('2d');
      const protobufStat = serializationStats.find(stat => stat.name === 'protobuf.js');
      const pbfStat = serializationStats.find(stat => stat.name === 'pbf');
      new Chart(ctx, {
        type: 'bar',
        data: {
          labels: ['Protobuf.js (Optimized)', 'Pbf (Optimized)'],
          datasets: [{
            label: 'Serialization Duration (ms)',
            data: [protobufStat.finalSerializeDuration, pbfStat.finalSerializeDuration],
            backgroundColor: [
              'rgba(153, 102, 255, 0.8)',
              'rgba(255, 159, 64, 0.8)'
            ],
            borderColor: [
              'rgba(153, 102, 255, 1)',
              'rgba(255, 159, 64, 1)'
            ],
            borderWidth: 1
          }]
        },
        options: {
          responsive: true,
          scales: {
            y: {
              beginAtZero: true,
              title: {
                display: true,
                text: 'Duration (ms)'
              }
            }
          },
          plugins: {
            title: {
              display: true,
              text: 'Protobuf.js vs Pbf Performance Comparison'
            }
          }
        }
      });
    }
    function createRustChart() {
      const ctx = document.getElementById('rustChart').getContext('2d');
      const sortedStats = [...serializationStats].sort((a, b) => a.rustSerializeDuration - b.rustSerializeDuration);
      new Chart(ctx, {
        type: 'bar',
        data: {
          labels: sortedStats.map(stat => stat.name),
          datasets: [{
            label: 'Rust Implementation (ms)',
            data: sortedStats.map(stat => stat.rustSerializeDuration),
            backgroundColor: 'rgba(255, 99, 132, 0.8)',
            borderColor: 'rgba(255, 99, 132, 1)',
            borderWidth: 1
          }, {
            label: 'JavaScript Optimized (ms)',
            data: sortedStats.map(stat => stat.finalSerializeDuration),
            backgroundColor: 'rgba(54, 162, 235, 0.8)',
            borderColor: 'rgba(54, 162, 235, 1)',
            borderWidth: 1
          }]
        },
        options: {
          responsive: true,
          scales: {
            y: {
              beginAtZero: true,
              title: {
                display: true,
                text: 'Duration (ms)'
              }
            }
          },
          plugins: {
            title: {
              display: true,
              text: 'Rust vs JavaScript Optimized Performance'
            }
          }
        }
      });
    }
    document.addEventListener('DOMContentLoaded', function() {
      createFinalResultsChart();
      createPreOptimizationChart();
      createBebopChart();
      createProtobufChart();
      createRustChart();
    });
    </script>
</head>


# Serialization from NodeJS

## Introduction

This is intended as a companion to [Binary Formats are Better than JSON in
Browsers](binary_formats_are_better_than_json_in_browsers.html). In that post, I
explored how several binary formats outperfom JSON in browsers. In this post,
I'll be focused on serialization in backend services written in NodeJS.

I'll show that several binary formats outperform JSON, though things are subtle
and more annoying. For all of these tests, the code is available
[here](https://github.com/adamfaulkner/serialization_from_nodejs). I used the
NYC citibike dataset as my data for benchmarking.

Here are the final results, comparing the formats that I tested:

<div id="finalResults">
<canvas id="finalResultsChart" width="400" height="200"></canvas>
</div>

## Why is this interesting?

Naively, one would assume that binary formats are always better than JSON, since
they produce a smaller output, and "less bytes = faster". However, JSON is
pretty tightly integrated with v8 and can make use of optimizations that are not
available to other formats.

In a past job, I wrote a doc about how avro didn't perform as well as JSON for
serialization, so we shouldn't use it. This seems to no longer be the case, so I
figured I'd write this follow up.

I also found that it was important to optimize a couple of things in the
serialization benchmark to get a good result. Without optimization, some of
these serializers were 10x slower. I wanted to document this somewhere, in case
it is helpful.

## Optimizations

At the beginning of these tests, the results were radically different:
<div id="preOptimizationComparisons">
<canvas id="preOptimizationChart" width="400" height="200"></canvas>
</div>

There were two big changes that I made to several of these serializers which were responsible for this speedup:

- Create less garbage when setting up the object to serialize.
- Pre-allocate appropriately sized buffers.

## Profiling and Allocation Sampling:

When I started CPU profiling this benchmark, it became very clear that we were
spending almost all of our time inside the garbage collector. I quickly switched
to looking at allocation sampling. Node makes this very easy using the
[inspector](https://nodejs.org/api/inspector.html) module -- third party
libraries are no longer required for doing scoped profiling!

## Creating the input to the serializer without creating lots of garbage.

The first thing I noticed when optimizing this code was that we were creating
most of our garbage when setting up the object for serialization. This is code
that looked like this:

```typescript

	const response = {
		trips: trips.map((trip) => ({
			rideId: trip.rideId,
			rideableType: mapToAvroRideableType(trip.rideableType),
			startLat: trip.startLat || null,
			...
		})),
	};

```

This code was responsible for mapping between our internal types and the types
expected by our Avro schema. In this case, I needed to replace some `undefined`
with `null`, and remap enums. In other cases, I needed to slightly rename
fields, like `startTime` became `startTimeMs`.

At any rate, this created a huge amount of garbage, which bogged down our benchmark.

I was able to fix these by creating "remapper types", which looked like this:

```typescript
class AvroTripTransformer {
	constructor(private underlying: Trip) {}

	get rideId(): string {
		return this.underlying.rideId;
	}

	get rideableType(): string {
		return mapToAvroRideableType(this.underlying.rideableType);
	}

	get startLat(): number | null {
		return this.underlying.startLat || null;
	}
	...
}
```

This mostly eliminated the garbage created by these objects, which more than
doubled the speed of the avro benchmark. Other serializers had a noticeable, but
less dramatic speedup.

## Using an appropriately sized buffer.

The second big thing I noticed was that many serializers allocated a lot of
buffers. Most of the libraries that I looked at closely implemented dynamically
growing buffers by allocating a new buffer double the size of the original
buffer when it was full, and copying the data into the new buffer. This is a lot
of wasted effort in JavaScript, where Uint8Arrays are weirdly expensive relative
to other languages.

Some of these libraries permitted us to provide a buffer for the serializer to
use instead, so I could simply allocate a large enough buffer up front, and
avoid this cost.

Honestly, all of these libraries ought to just compute the length of the
serialized message first, then allocate an appropriately sized buffer.

[Avsc](https://github.com/mtth/avsc/tree/master) essentially does this, but in a
goofy way. Its underlying [`Tap`
implementation](https://github.com/mtth/avsc/blob/91d653f72906102448a059cb81692177bb678f52/lib/utils.js#L518-L525)
will silently overflow when presented with an object that is too big to
serialize. It will then explicitly allocate an appropriately sized buffer, and
repeat the serialization operation into this buffer. It would be faster to have
an explicit way to determine the size of a serialized message.

Other libraries, like [Msgpackr](https://github.com/kriszyp/msgpackr) do not
have a way to provide an appropriately sized buffer, but they do permit us to
reuse a buffer previously returned by a prior call to msgpacker. By using this
method and repeating the test a number of times, we can amortize out the initial
attempt which grows the buffer dynamically.

## What's up with Bebop?

<div id="bebopPreOptimizeVsOptimizeVsJSON">
<canvas id="bebopChart" width="400" height="200"></canvas>
</div>

While I was able to speed up Bebop considerably, it was still much slower than
JSON. It didn't have a reasonable way to provide a pre-allocated buffer to the
serializer. I suspect this would help considerably.

## What's up with Protobuf.js?

[Protobuf.js](https://github.com/protobufjs/protobuf.js) does not have good APIs
for implementing either optimization. It requires creating explicit, library
specific, `Message` objects, which we can't easily fake to avoid creating
garbage. It also doesn't have a good way to provide a pre-allocated buffer.

From what I can tell from reading the Protobuf.js writer code, buffer
pre-allocation shouldn't matter as much as it does for other libraries, because
Protobuf.js accumulates a linked list of items to serialize, [then allocates an
appropriately sized
buffer](https://github.com/protobufjs/protobuf.js/blob/f42297b29d15c8e0382744a83f5147a1aa978f42/src/writer.js#L448-L459).

Garbage collection accounts for a 85% of the time spent serializing protobuf
messages with Protobuf.js, so I'd guess that this fancy linked list stuff
probably costs more than it saves.

## Rant about Protobuf.js and the JavaScript ecosystem in general.

This business with Protobuf.js is kinda sad. There's nothing in the Protobuf
format that requires the serializer to be this slow.

I tried another library called [Pbf](https://github.com/mapbox/pbf), and it was
an order of magnitude faster. It was also around 88% smaller than Protobuf.js,
by lines of code. The code it generated was very easy to read and understand.

<div id="protobufVsPbf">
<canvas id="protobufChart" width="400" height="200"></canvas>
</div>

To make some broad generalizations, I've seen this kind of pattern with a lot of
JavaScript libraries. They don't really care much about performance and end up
being very bloated, with very little benefit to the end-user.

## Use a different language

Compared with minimally optimized Rust code, JavaScript is just very slow. This
is not surprising at all, but I think it bears remembering. If you have a
choice, don't use JavaScript on the server.

<div id="rustVsOptimized">
<canvas id="rustChart" width="400" height="200"></canvas>
</div>
