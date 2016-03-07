/**

 The Router is a structure that collects functions together that are related to the same routing
 unit.

 Each Router also requires a Presenter, through which any required changes are passed to.

 The generic type <T> - most likely a ViewController - is the item to be presented if this route
 is evaluated and determined to be a match to the current route.

 The current route path is set via a String. Paths are expected to be normalised before being
 passed to the Router, in so much as any string passed in - if valid - should be in a state that is
 able to match the appropriate route selector.

 Ie, hostname and protocol stripped, and string down-cased if required.

 */
public struct Router<T> {

    /**
     Presenter to pass route actions too
     */
    public var presenter: Presenter<T>

    /**
     The presenter to return if this route matches
     */
    public var presentable: T { return presenter.presentable }

    /**
     Determines if this Router handles the passed in String
     */
    public var handlesRoute: String -> Bool = { _ in false }

    /**
     Passes actions to the Presenter to update the view to the provided String
     */
    public var setRoute: String -> Void = { _ in }

    /**
     Returns an array presenters (T) that match the passed in String. The actual array returned can
     vary depending in the behaviour assigned to this router. Ie, a Junction Router returns an
     array of all immediate ancestors, weather they match or now, whereas a Stack Router traverses
     nested children to find a match and returns the matched ancestor tree.
     */
    public var getStack: String -> [T]? = { _ in nil }

    /**
     Primary Router initialiser

     Sets each of router variables to the passed in closures.

     - parameter presenter:    Presenter<T>
     - parameter handlesRoute: (route: String) -> Bool
     - parameter setRoute:     (route: String) -> Void
     - parameter getStack:     (route: String) -> [T]?
     */
    public init(
        _ presenter: Presenter<T>,
        handlesRoute: (String -> Bool)? = nil,
        setRoute: (String -> Void)? = nil,
        getStack: (String -> [T]?)? = nil) {

            self.presenter = presenter

            if let handlesRoute = handlesRoute {
                self.handlesRoute = handlesRoute
            }

            if let setRoute = setRoute {
                self.setRoute = setRoute
            }

            if let getStack = getStack {
                self.getStack = getStack
            }
    }
}
