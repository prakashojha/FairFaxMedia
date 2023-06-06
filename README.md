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
- Contains app level data e.g. environment, resources and Dependencies
## CORE
- Contains Network Service to make Network/API calls
## PRESENTATION
- Contains UI and ViewModels
- ViewModels use the services of Domain layer to fetch data and update UI
## DOMAIN
- Independent layer
- Exposes Repo to be implemented by Data Later to provide data to domain layer.
- Implenets UserInteractor to interact with Presentation layer.
## DATA
- Responsible for making network calls.
- Pass data back to Domain layer in the required model.

