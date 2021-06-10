#if CX_PRIVATE_SHIM
import _CXShim
#else
import CXShim
#endif

extension AnyPublisher {
    
    public init(_ receiveSubscriber: @escaping (AnySubscriber<Output, Failure>) -> Void) {
        let pub = TransparentPublisher(receiveSubscriber)
        self.init(pub)
    }
}

private class TransparentPublisher<Output, Failure: Error>: Publisher {
    
    let _rcvSubscriber: (AnySubscriber<Output, Failure>) -> Void
    
    init(_ receiveSubscriber: @escaping (AnySubscriber<Output, Failure>) -> Void) {
        self._rcvSubscriber = receiveSubscriber
    }
    
    func receive<S: Subscriber>(subscriber: S) where Failure == S.Failure, Output == S.Input {
        self._rcvSubscriber(AnySubscriber(subscriber))
    }
}
