
# Planets

Planets is a demo app utilising caching and remote strategies to display data about some poular planets.

## Installation

Open Planets.xcworkspace , navigate to the PlanetsApp target and run on any simulator

## Comments

The test strategy utilises abstract interfaces to test behaviour whilst hiding concrete implementations.
The caching was done using a CoreData scheme however the design is flexible enough to allow other components implementing the PlanetsLoader protocol to be used. The PlanetsStoreSpecs mark out in test the use case requirements for the store

An MVP pattern was chosen showing a clean seperation from UI and Model with a platform agnostic presentation layer. 
There are memory management techniques to weakify some components at the compostion layer to avoid leaking these details to UI componenets.

## Future work

The compostion is mostly done in the SceneDelegate and better use could be made of injection containers to keep this tidy. As features grow I would aim to use an injection container strategy and flesh out relevant scopes for object lifetimes. 

## Testing

Tests include isolated and integration tests where no mocks are used but only happy paths are tested.
Localisations are also tested so that all Localised string within the Presentation bundle have a key value pair that are not equal

Given more time I would like to test also the Composite and Decorator classes to further increase coverage
