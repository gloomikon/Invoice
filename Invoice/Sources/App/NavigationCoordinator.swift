import Depin
import XCoordinator

class NavigationCoordinator<RouteType: Route>: XCoordinator.NavigationCoordinator<RouteType> {

    @Injected var moduleBuilder: ModuleBuilder
}
