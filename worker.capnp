using Workerd = import "/workerd/workerd.capnp";

const config :Workerd.Config = (
    services = [
        (name = "main", worker = .worker),
    ],
    sockets = [
        (service = "main", name = "http", address = "*:8080", http = ()),
    ]
);

const worker :Workerd.Worker = (
    modules = [
        (name = "worker", esModule = embed "dist/index.js"),
        # We also have an HTML file containing the client side of the app. We embed this as a text
        # module, so that it can be served to the client.
        (name = "./f5bbf199decd89a3f0c75d721b5a235524ca7235-chat.html", text = embed "dist/f5bbf199decd89a3f0c75d721b5a235524ca7235-chat.html"),
    ],
    durableObjectNamespaces = [
        (className = "ChatRoom", uniqueKey = "210bd0cbd803ef7883a1ee9d86cce06e"),
        (className = "RateLimiter", uniqueKey = "b37b1c65c4291f3170033b0e9dd30ee1"),
    ],
    compatibilityDate = "2024-02-19",
    # To use Durable Objects we must declare how they are stored.
    # As of this writing, `workerd` supports in-memory-only Durable Objects -- so, not really
    # "durable", as all data is lost when workerd restarts. However, this still allows us to run the
    # chat demo for testing purposes. (We plan to add actual storage for Durable Objects eventually,
    # but the storage system behind Cloudflare Workers is inherently tied to our network so did not
    # make sense to release as-is.)
    durableObjectStorage = (inMemory = void),
    # We must declare bindings to allow us to call back to our own Durable Object namespaces. These
  # show up as properties on the `env` object passed to `fetch()`.
  bindings = [
    (name = "rooms", durableObjectNamespace = "ChatRoom"),
    (name = "limiters", durableObjectNamespace = "RateLimiter"),
  ]
);