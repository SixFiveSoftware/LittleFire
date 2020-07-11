# LittleFire
Lightweight networking library for basic HTTP functionality for your iOS app.

## Why another networking library?
This is intended to be small. There are other small libraries out there, which are fantastic. But staying small is another thing. I have used AlamoFire and Moya extensively in my career, and love them. But sometimes you just need something small, or a corporation or client you're working with has restrictions on dependencies, or even makes the process so difficult to bring in a dependency that it's easier to write your own. The goal with LittleFire is to allow people to reuse these few files if need be, or bring in via SwiftPM.

## Usage
LittleFire introduces an extension to the Codable types, originally created by my friend Ben Winters, called ResponseCodable. It is the combination of ResponseDecodable and RequestEncodable. The types you expect to decode upon an HTTP response should conform to ResponseDecodable, and the bodies you add to be encoded in a request should conform to RequestEncodable. 

Start by creating a provider.
```
let provider = ServiceProvider()
```

Next, create a service. The service is generic over the type you expect to decode. It's recommended to create your own service as an enum, that conforms to the `Service` protocol.
```
provider.request(service: MyTodoService<MyTodoObject>.getTodo(1))
```

Currently, LittleFire uses PromiseKit to handle async calls. So, the call above to request a `MyTodoObject` can be fetched like so:
```
provider.request(service: MyTodoService<MyTodoObject>.getTodo(1))
  .then { todo in self.updateUI(with: todo) }
	.catch { error in self.handle(error: error) }
```
