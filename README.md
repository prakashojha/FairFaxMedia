# FairFaxMedia

# Requirements
- XCode 14.3.1
- iOS 13.X and above

# Architecture
- Clean Architecture
- MVVM for presentation layer
- SOLID principles

# Project Structure
<img width="251" alt="Screenshot 2023-06-06 at 4 55 41 PM" src="https://github.com/prakashojha/FairFaxMedia/assets/8487111/0a703e6a-073a-46fb-87ba-380212469a98">

## APP
- Contains app level data e.g. environment, resources, dependencies etc.
## CORE
- Contains Network Service to make Network/API calls
- Adopt and confirms to `RemoteNetworkServiceRepo`
## PRESENTATION
- Contains Views, models and ViewModels.
- ViewModels use the services of Domain layer to fetch data and update UI
- Uses `ArticleUseCaseInteractor` to interact with Domain layer
## DOMAIN
- Independent layer
- Contain all the business use cases `ArticleUseCases`
- Exposes `ArticleDataRepo` to be implemented by Data Layer.
- Adopt and confirms to `ArticleUseCaseInteractor` Repo.
## DATA
- Uses `RemoteNetworkService` from Core layer to get data from network.
- Provides `RemoteNetworkService` a model, `ArticleDataModel` to decode downloaded data into.
- Transforms data from `ArticleDataModel` model to `ArticleEntity` model
- Pass `ArticleEntity` model back to Domain layer.
- Adoppt and confirms to `ArticleDataRepo` exposed by Domain Layer.

