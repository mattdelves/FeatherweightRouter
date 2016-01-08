# Beeline
Swift based UIKit and AppKit Router

Beeline is a declarative routing handler that decouples ViewControllers from each other. It follows a Coordinator and Presenter pattern, also referred to as Flow Controllers.

The Coordinator is constructed by declaring a route hierarchy mapped with a URL structure.

## Beeline principles

### UI is a representation of State

As the State changes over time, so will the UI projection of that State.

Given any State value the UI must be **predictable** and **repeatable**.

### Device dependent state should be seperate from the Application State.

Displaying the same State on a phone and tablet for example, can result in different UIs. The device dependent state should remain on that device. An OS X and iOS app can use the same State and logic classes and interchange Routers for representing the State.


### Application State encapsulate Path

If the UI is a projection of State, then the current Path should be included in that State too.


### UI can generate actions to update Path values in the State

The user tapping a back button is easy to capture and generate and action that updates the State Path which causes the UI change. But a user 'swiping' back a view is harder to capture. It should instead generate an action on completion to update the State Path. Then, if the current UI already matches the new State no UI changes are necessary.

### All View components are predictable projections of State

Each view component should be testable and predictable. If any component that makes up the UI is not predictable, then neither is the UI.

## Goal Usage

```swift
import Beeline

func appRouterFromCreateRouterFuncs<T>() -> Router<T> {

	return junctionRouter(tabBarPresenter(), [
		stackRouter(navigationBarPresenter(title: "Animals"), [
			route("animals", animalListPresenter, [
				route("(?<id>\\w+)", animalPresenter),
			]),
		]),
		stackRouter(navigationBarPresenter(title: "Zoos"), [
			route("zoos", zooListPresenter, [
				route("(?<id>\\w+)", zooPresenter),
			]),
		]),
	])
}
```

### Alternative usages for discussion

```swift
func appRoutesFromArray(views: Views) -> Router {
	return router([
		"animals": views.animalList,
		"animals/\\w+": view.animalDetail,
		"zoos": views.zooList,
		"zoos/\\w+": views.zooDetail,
	])
}

func appRoutesAsClasses<T>() -> Router<T> {
	return BeelineTabBarController([
		BeelineNavigationController([
			AnimalListViewController("animals", [
				AnimalDetailViewController("(?<id>\\w+)"),
			]),
		]),
		BeelineNavigationController([
			ZooListViewController("zoos", [
				ZooDetailViewController("(?<id>\\w+)"),
			]),
		]),
	])
}

func appRoutesAsClosures<T>() -> Router<T> {
	return junctionRouter(UITabBarController) { add in
		add.stackController(UINavigationController) { add in
			add.route("animals", animalListPresenter) { add in
				add.route("(?<id>\\w+)", animalDetailPresenter)
			}
		}
		add.stackController(UINavigationController) { add in
			add.route("zoos", zooListPresenter) { add in
				add.route("(?<id>\\w+)", zooDetailPresenter)
			}
		}
	}
}
```

## Glossary

- **Path / URL**: A String representing the current view or UI state the application is in. This can include hierarchy and view dependent information as parameters or query values. Ie, viewing a user profile
- **State**: A stream of values over time.
- **UI**: User Interface: A visual representation of the State that a user can interact with.