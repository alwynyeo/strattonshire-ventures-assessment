Strattonshire Ventures Assessment
======================

Overview
--------

This iOS application uses the MVVM architecture (Model-View-ViewModel) to efficiently manage data flow and ensure a seamless user experience. The application retrieves data from both persistent storage and the network to provide up-to-date information while maintaining quick access to previously stored data.

Architecture
------------

### MVVM (Model-View-ViewModel)

-   **Model**: Represents the data structure.
-   **View**: Displays the data to the user and handles user interactions.
-   **ViewModel**: Acts as a mediator between the View and Model. It retrieves data from the Network Service and updates the View.

High-Level Flow
---------------

1.  **Initial Load**:

    -   Fetch the latest data from the API via the Network Service.
    -   Display the retrieved data to the user.
    -   Persist the latest data in Core Data using the Persistence Service.
    -   If no internet connection, fetch data from Core Data via the Persistence Service.
2.  **Data Flow**:

    -   The ViewModel initiates a data fetch request.
    -   The ViewModel requests data from the Network Service.
    -   The Network Service fetches data via URLSession and saves it to Core Data using the Persistence Service.
    -   The Network Service then returns the data to the ViewModel.
    -   The ViewModel updates the View with the retrieved data.

Low-Level Flow
--------------

1.  **Persistent Data Retrieval**:

    -   The ViewModel requests data from the Network Service.
    -   The Network Service first attempts to fetch data from the API.
    -   If successful, the Network Service saves the data to Core Data via the Persistence Service.
    -   Data is then returned from the Network Service to the ViewModel.
    -   If the network request fails, the ViewModel can fetch data directly from Core Data via the Persistence Service.
    -   Data flows from Core Data to the ViewModel, and then to the View.
2.  **Network Data Retrieval**:

    -   The ViewModel requests data from the Network Service.
    -   The Network Service fetches data via URLSession.
    -   Upon successful retrieval, the Network Service saves the data to Core Data using the Persistence Service.
    -   The Network Service returns the data to the ViewModel.
    -   The ViewModel then updates the View with the latest data.
        

Tech Stack
----------

-   **Layout**:

    -   UICollectionView
    -   UICollectionViewCompositionalLayout
-   **Data Source**:

    -   UICollectionViewDiffableDataSource
-   **Package Manager**:

    -   Swift Package Manager
-   **Third-Party Libraries**:

    -   Kingfisher (for image caching)
-   **Persistent Storage**:

    -   Core Data
-   **Networking**:

    -   URLSession
-   **Version Control**:

    -   Git
-   **Minimum iOS Version**:

    -   iOS 17.5
-   **API**:

    -   [Free Test API](https://freetestapi.com/)


Running the App on a Simulator
------------------------------

To run the app on a simulator, follow these steps:

1. **Clone the repository**:
    ```bash
    git clone git@github.com:alwynyeo/strattonshire-ventures-assessment.git
    cd strattonshire-ventures-assessment
    ```

2. **Open the project in Xcode**:
    ```bash
    open strattonshire-ventures-assessment.xcodeproj
    ```

3. **Create schemes**:
    - In Xcode, go to `Product` -> `Scheme` -> `Manage Schemes...`
    - Click on the `Autocreate Schemes Now` button to generate the necessary schemes.

4. **Run the app**:
    - Select the desired simulator (e.g., iPhone 14) from the device toolbar.
    - Press `Cmd + R` to build and run the app on the selected simulator.
