# 🎨 Visual Widget Diagrams - Complete Reference

This document contains all the visual widget trees and component breakdowns for the Flutter frontend.

---

## 🏗️ App Root Structure

### MyApp → MaterialApp Hierarchy

```mermaid
graph TD
    main[main.dart<br/>void main]
    main --> runApp[runApp]
    runApp --> MyApp[MyApp<br/>StatelessWidget]
    
    MyApp --> MaterialApp
    
    MaterialApp --> Title[title: 'Food Order App']
    MaterialApp --> Theme[theme: ThemeData<br/>Orange color scheme]
    MaterialApp --> InitRoute[initialRoute: '/']
    MaterialApp --> OnGenerate[onGenerateRoute<br/>Dynamic routing]
    
    OnGenerate --> Routes[Route Handler]
    
    Routes --> Route1[/ → SplashScreen]
    Routes --> Route2[/login → LoginScreen]
    Routes --> Route3[/register → RegisterScreen]
    Routes --> Route4[/user-home → UserHomeScreen]
    Routes --> Route5[/restaurant-home → RestaurantHomeScreen]
    Routes --> Route6[/admin-home → AdminHomeScreen]
    Routes --> Route7[/restaurant-menu → RestaurantMenuScreen]
    Routes --> Route8[/my-orders → MyOrdersScreen]
    Routes --> Route9[/manage-menu → ManageMenuScreen]
    Routes --> Route10[/restaurant-orders → RestaurantOrdersScreen]
    
    style MyApp fill:#ff9800
    style MaterialApp fill:#ffb74d
    style Routes fill:#ffe0b2
```

---

## 📱 Screen Widget Trees

### 1. SplashScreen Widget Tree

```mermaid
graph TD
    Splash[SplashScreen<br/>StatefulWidget]
    Splash --> State[_SplashScreenState]
    
    State --> initState[initState<br/>Call _checkSession]
    State --> build[build method]
    
    build --> Scaffold1[Scaffold<br/>backgroundColor: orange]
    
    Scaffold1 --> Body1[body: Center]
    Body1 --> Column1[Column<br/>mainAxisAlignment: center]
    
    Column1 --> Icon1[Icon<br/>restaurant_menu<br/>size: 100<br/>color: white]
    Column1 --> SizedBox1[SizedBox<br/>height: 24]
    Column1 --> Text1[Text<br/>'Food Order App'<br/>fontSize: 32<br/>bold<br/>white]
    Column1 --> SizedBox2[SizedBox<br/>height: 48]
    Column1 --> Loading[CircularProgressIndicator<br/>color: white]
    
    initState -.->|1 second delay| Check[_checkSession]
    Check -.->|Check StorageHelper| Token{Token exists?}
    Token -->|Yes| Navigate1[Navigate to role-based home]
    Token -->|No| Navigate2[Navigate to /login]
    
    style Splash fill:#ff9800
    style State fill:#ffb74d
    style Scaffold1 fill:#ffe0b2
```

---

### 2. LoginScreen Widget Tree

```mermaid
graph TD
    Login[LoginScreen<br/>StatefulWidget]
    Login --> LoginState[_LoginScreenState]
    
    LoginState --> Controllers[Controllers<br/>_emailController<br/>_passwordController]
    LoginState --> StateVar[State Variables<br/>_isLoading: bool]
    
    LoginState --> BuildMethod[build method]
    BuildMethod --> Scaffold2[Scaffold<br/>backgroundColor: grey]
    
    Scaffold2 --> Body2[body: Center]
    Body2 --> Scroll[SingleChildScrollView<br/>padding: 24]
    Scroll --> Container2[Container<br/>maxWidth: 400]
    
    Container2 --> Column2[Column<br/>mainAxisAlignment: center]
    
    Column2 --> Icon2[Icon<br/>restaurant_menu<br/>size: 80<br/>color: orange]
    Column2 --> Box1[SizedBox height: 24]
    Column2 --> Title2[Text<br/>'Login'<br/>fontSize: 32<br/>bold]
    Column2 --> Box2[SizedBox height: 32]
    Column2 --> EmailField[CustomTextField<br/>label: 'Email'<br/>controller: _emailController<br/>keyboardType: email]
    Column2 --> Box3[SizedBox height: 16]
    Column2 --> PassField[CustomTextField<br/>label: 'Password'<br/>controller: _passwordController<br/>obscureText: true]
    Column2 --> Box4[SizedBox height: 24]
    Column2 --> LoginBtn[CustomButton<br/>text: 'Login'<br/>onPressed: _handleLogin<br/>isLoading: _isLoading]
    Column2 --> Box5[SizedBox height: 16]
    Column2 --> RegRow[Row<br/>"Don't have account?" + TextButton]
    
    LoginBtn -.->|onClick| HandleLogin[_handleLogin method]
    HandleLogin -.-> ApiCall[ApiService.login]
    ApiCall -.-> SaveData[StorageHelper.saveToken<br/>StorageHelper.saveUser]
    SaveData -.-> NavByRole[Navigate based on role]
    
    style Login fill:#2196f3
    style LoginState fill:#64b5f6
    style Scaffold2 fill:#bbdefb
```

---

### 3. UserHomeScreen Widget Tree

```mermaid
graph TD
    UserHome[UserHomeScreen<br/>StatefulWidget]
    UserHome --> UserState[_UserHomeScreenState]
    
    UserState --> StateVars[State Variables<br/>_restaurants: List<br/>_allMenuItems: List<br/>_filteredMenuItems: List<br/>_isLoading: bool<br/>_searchQuery: string<br/>_selectedCategory: string]
    
    UserState --> InitState2[initState<br/>_loadData<br/>_loadStats]
    UserState --> BuildMethod2[build method]
    
    BuildMethod2 --> Scaffold3[Scaffold<br/>backgroundColor: grey]
    
    Scaffold3 --> AppBar3[AppBar<br/>title: 'Order Food'<br/>backgroundColor: orange]
    Scaffold3 --> Body3[body: Column or Loading]
    
    AppBar3 --> Actions1[actions]
    Actions1 --> OrdersIcon[IconButton<br/>receipt_long<br/>→ /my-orders]
    Actions1 --> LogoutIcon[IconButton<br/>logout<br/>→ _logout]
    
    Body3 --> Loading2{_isLoading?}
    Loading2 -->|Yes| Spinner[CircularProgressIndicator]
    Loading2 -->|No| MainColumn[Column]
    
    MainColumn --> StatsCard[Statistics Card<br/>Container with gradient]
    MainColumn --> SearchBar[Search TextField<br/>Container padding: 16]
    MainColumn --> CategoryRow[Category Filter<br/>SingleChildScrollView horizontal]
    MainColumn --> MenuGrid[Expanded<br/>GridView.builder]
    
    StatsCard --> StatsContent[Column<br/>2 Rows of stats]
    StatsContent --> Row1[Row<br/>Total Orders | Delivered]
    StatsContent --> Row2[Row<br/>This Month | Total Spent]
    
    SearchBar --> TextField1[TextField<br/>hintText: 'Search for dishes'<br/>prefixIcon: search<br/>onChanged: _onSearchChanged]
    
    CategoryRow --> Chips[Wrap<br/>FilterChip widgets]
    Chips --> AllChip[FilterChip 'All']
    Chips --> FastFood[FilterChip 'Fast Food']
    Chips --> Beverages[FilterChip 'Beverages']
    Chips --> Etc[FilterChip '...more categories']
    
    MenuGrid --> ItemCards[MenuItemCard widgets<br/>for each filtered item]
    
    ItemCards --> CardStructure[MenuItemCard]
    
    style UserHome fill:#4caf50
    style UserState fill:#81c784
    style Scaffold3 fill:#c8e6c9
```

---

### 4. MenuItemCard Widget (Reusable Component)

```mermaid
graph TD
    Card[MenuItemCard<br/>StatelessWidget]
    Card --> Props[Properties<br/>MenuItem item<br/>VoidCallback onTap]
    
    Card --> BuildCard[build method]
    BuildCard --> GestureDetector[GestureDetector<br/>onTap: onTap]
    
    GestureDetector --> CardWidget[Card<br/>elevation: 2<br/>margin: 8]
    
    CardWidget --> Column3[Column<br/>crossAxisAlignment: stretch]
    
    Column3 --> ImageSection[Image Section]
    Column3 --> ContentSection[Content Padding]
    
    ImageSection --> ClipRRect[ClipRRect<br/>borderRadius: top]
    ClipRRect --> Image1[Image.network<br/>item.image<br/>height: 150<br/>fit: cover]
    
    ContentSection --> Padding1[Padding: 12]
    Padding1 --> NameText[Text<br/>item.name<br/>fontSize: 16<br/>bold]
    Padding1 --> Box6[SizedBox height: 4]
    Padding1 --> DescText[Text<br/>item.description<br/>fontSize: 12<br/>maxLines: 2<br/>overflow: ellipsis]
    Padding1 --> Box7[SizedBox height: 8]
    Padding1 --> BottomRow[Row<br/>mainAxisAlignment: spaceBetween]
    
    BottomRow --> PriceRow[Row - Price + Veg indicator]
    BottomRow --> AddButton[IconButton<br/>add_circle<br/>color: orange]
    
    PriceRow --> PriceText[Text<br/>'₹${item.price}'<br/>fontSize: 16<br/>bold]
    PriceRow --> VegIcon[Icon<br/>circle<br/>size: 12<br/>green/red]
    
    style Card fill:#ff9800
    style CardWidget fill:#ffb74d
    style Column3 fill:#ffe0b2
```

---

### 5. RestaurantHomeScreen Widget Tree

```mermaid
graph TD
    RestHome[RestaurantHomeScreen<br/>StatefulWidget]
    RestHome --> RestState[_RestaurantHomeScreenState]
    
    RestState --> StateVars2[State Variables<br/>_restaurant: Restaurant?<br/>_isLoading: bool<br/>_stats: Map]
    
    RestState --> Init3[initState<br/>_loadRestaurant<br/>_loadStats]
    RestState --> Build3[build method]
    
    Build3 --> Scaffold4[Scaffold<br/>backgroundColor: grey]
    
    Scaffold4 --> AppBar4[AppBar<br/>'Restaurant Dashboard'<br/>backgroundColor: blue]
    Scaffold4 --> Body4[body]
    
    AppBar4 --> Actions2[actions]
    Actions2 --> MenuAction[IconButton<br/>restaurant_menu<br/>→ /manage-menu]
    Actions2 --> OrdersAction[IconButton<br/>receipt<br/>→ /restaurant-orders]
    Actions2 --> LogoutAction[IconButton logout]
    
    Body4 --> Loading3{_isLoading?}
    Loading3 -->|Yes| Spinner2[CircularProgressIndicator]
    Loading3 -->|No| MainContent[RefreshIndicator<br/>SingleChildScrollView]
    
    MainContent --> Padding2[Padding: 16]
    Padding2 --> Column4[Column<br/>crossAxisAlignment: stretch]
    
    Column4 --> RestInfo[Restaurant Info Card]
    Column4 --> Box8[SizedBox height: 16]
    Column4 --> StatsGrid[Stats Grid]
    Column4 --> Box9[SizedBox height: 16]
    Column4 --> QuickActions[Quick Action Buttons]
    
    RestInfo --> Card1[Card]
    Card1 --> ListTile[ListTile<br/>title: restaurant.name<br/>subtitle: address<br/>trailing: Status Switch]
    
    StatsGrid --> GridView1[GridView.count<br/>crossAxisCount: 2<br/>4 stat cards]
    GridView1 --> StatCard1[Stat Card<br/>Total Orders]
    GridView1 --> StatCard2[Stat Card<br/>Pending Orders]
    GridView1 --> StatCard3[Stat Card<br/>Today's Revenue]
    GridView1 --> StatCard4[Stat Card<br/>Total Revenue]
    
    QuickActions --> Row3[Row<br/>2 expanded buttons]
    Row3 --> ManageBtn[ElevatedButton<br/>'Manage Menu']
    Row3 --> ViewBtn[ElevatedButton<br/>'View Orders']
    
    style RestHome fill:#2196f3
    style RestState fill:#64b5f6
    style Scaffold4 fill:#bbdefb
```

---

### 6. AdminHomeScreen Widget Tree

```mermaid
graph TD
    AdminHome[AdminHomeScreen<br/>StatefulWidget]
    AdminHome --> AdminState[_AdminHomeScreenState<br/>with SingleTickerProviderStateMixin]
    
    AdminState --> StateVars3[State Variables<br/>_tabController<br/>_restaurants: List<br/>_users: List<br/>_orders: List<br/>_stats: Map<br/>_filter: string]
    
    AdminState --> Init4[initState<br/>TabController length: 4<br/>_loadAllData]
    AdminState --> Build4[build method]
    
    Build4 --> Scaffold5[Scaffold]
    
    Scaffold5 --> AppBar5[AppBar<br/>'Admin Dashboard'<br/>backgroundColor: purple]
    Scaffold5 --> Body5[body: TabBarView]
    
    AppBar5 --> Actions3[actions: logout]
    AppBar5 --> Bottom[bottom: TabBar]
    
    Bottom --> Tab1[Tab<br/>icon: dashboard<br/>text: 'Overview']
    Bottom --> Tab2[Tab<br/>icon: restaurant<br/>text: 'Restaurants']
    Bottom --> Tab3[Tab<br/>icon: people<br/>text: 'Users']
    Bottom --> Tab4[Tab<br/>icon: receipt<br/>text: 'Orders']
    
    Body5 --> TabView[TabBarView<br/>4 children]
    
    TabView --> OverviewTab[Overview Tab<br/>Statistics Dashboard]
    TabView --> RestaurantsTab[Restaurants Tab<br/>Approval Management]
    TabView --> UsersTab[Users Tab<br/>User List]
    TabView --> OrdersTab[Orders Tab<br/>Order Monitoring]
    
    OverviewTab --> StatCards2[GridView<br/>Platform statistics]
    StatCards2 --> TotalRest[Card<br/>Total Restaurants]
    StatCards2 --> ActiveRest[Card<br/>Active Restaurants]
    StatCards2 --> TotalUsers[Card<br/>Total Users]
    StatCards2 --> TotalOrders2[Card<br/>Total Orders]
    StatCards2 --> Revenue[Card<br/>Total Revenue]
    StatCards2 --> Pending[Card<br/>Pending Approvals]
    
    RestaurantsTab --> FilterSection[Filter Chips<br/>All/Pending/Approved/Rejected]
    RestaurantsTab --> RestList[ListView.builder<br/>Restaurant cards]
    
    RestList --> RestCard[Card for each restaurant]
    RestCard --> RestDetails[ListTile<br/>name, status, etc.]
    RestCard --> ActionButtons[Row<br/>Approve/Reject buttons]
    
    UsersTab --> UserList[ListView.builder<br/>User cards]
    UserList --> UserCard[Card<br/>User details]
    
    OrdersTab --> OrderList[ListView.builder<br/>Order cards]
    OrderList --> OrderCard[Card<br/>Order details]
    
    style AdminHome fill:#9c27b0
    style AdminState fill:#ba68c8
    style Scaffold5 fill:#e1bee7
```

---

## 🧩 Reusable Widget Components

### CustomButton Widget

```mermaid
graph TD
    CustomBtn[CustomButton<br/>StatelessWidget]
    CustomBtn --> Props2[Properties<br/>String text<br/>VoidCallback onPressed<br/>bool isLoading = false]
    
    CustomBtn --> Build5[build method]
    Build5 --> SizedBox3[SizedBox<br/>width: double.infinity<br/>height: 50]
    
    SizedBox3 --> ElevatedBtn[ElevatedButton<br/>onPressed: isLoading ? null : onPressed]
    
    ElevatedBtn --> Style[style: ElevatedButton.styleFrom<br/>backgroundColor: orange<br/>foregroundColor: white<br/>borderRadius: 8]
    
    ElevatedBtn --> Child{isLoading?}
    Child -->|Yes| Spinner3[CircularProgressIndicator<br/>color: white]
    Child -->|No| BtnText[Text<br/>text<br/>fontSize: 16<br/>bold]
    
    style CustomBtn fill:#ff9800
    style ElevatedBtn fill:#ffb74d
```

### CustomTextField Widget

```mermaid
graph TD
    CustomTF[CustomTextField<br/>StatelessWidget]
    CustomTF --> Props3[Properties<br/>String label<br/>TextEditingController controller<br/>bool obscureText = false<br/>TextInputType keyboardType]
    
    CustomTF --> Build6[build method]
    Build6 --> TextField2[TextField]
    
    TextField2 --> Controller2[controller: controller]
    TextField2 --> Obscure[obscureText: obscureText]
    TextField2 --> Keyboard[keyboardType: keyboardType]
    TextField2 --> Decoration[decoration: InputDecoration]
    
    Decoration --> Label[labelText: label]
    Decoration --> Border1[border: OutlineInputBorder<br/>borderRadius: 8]
    Decoration --> Filled[filled: true<br/>fillColor: white]
    
    style CustomTF fill:#2196f3
    style TextField2 fill:#64b5f6
```

---

## 🎯 Widget Composition Examples

### Example: Order Dialog Composition

```mermaid
graph TD
    OrderDialog[_OrderDialog<br/>StatefulWidget]
    OrderDialog --> DialogState[State<br/>_quantity: int = 1]
    
    DialogState --> Build7[build method]
    Build7 --> AlertDialog1[AlertDialog]
    
    AlertDialog1 --> Title3[title: Text<br/>'Place Order']
    AlertDialog1 --> Content1[content: Column]
    AlertDialog1 --> Actions4[actions: List]
    
    Content1 --> ItemName[Text<br/>item.name<br/>fontSize: 18<br/>bold]
    Content1 --> Box10[SizedBox height: 8]
    Content1 --> ItemPrice[Text<br/>'₹${item.price}'<br/>fontSize: 16]
    Content1 --> Box11[SizedBox height: 16]
    Content1 --> QtyRow[Row<br/>Quantity selector]
    Content1 --> Box12[SizedBox height: 16]
    Content1 --> TotalRow[Row<br/>Total amount]
    
    QtyRow --> MinusBtn[IconButton<br/>remove_circle<br/>onPressed: decrease]
    QtyRow --> QtyText[Text<br/>_quantity<br/>fontSize: 18]
    QtyRow --> PlusBtn[IconButton<br/>add_circle<br/>onPressed: increase]
    
    TotalRow --> TotalLabel[Text 'Total:']
    TotalRow --> TotalAmount[Text<br/>'₹${item.price * _quantity}'<br/>bold]
    
    Actions4 --> CancelBtn[TextButton<br/>'Cancel'<br/>pop false]
    Actions4 --> PlaceBtn[ElevatedButton<br/>'Place Order'<br/>_placeOrder]
    
    PlaceBtn -.-> ApiCall2[ApiService.placeOrder]
    ApiCall2 -.-> Success[onOrderPlaced callback]
    Success -.-> Close[Navigator.pop]
    
    style OrderDialog fill:#4caf50
    style AlertDialog1 fill:#81c784
```

---

## 🎨 Theme & Styling Structure

### App Theme Configuration

```mermaid
graph TD
    MaterialApp2[MaterialApp]
    MaterialApp2 --> ThemeData1[theme: ThemeData]
    
    ThemeData1 --> ColorScheme1[colorScheme<br/>fromSeed: orange]
    ThemeData1 --> Material3[useMaterial3: true]
    
    ColorScheme1 --> Primary[primary: orange]
    ColorScheme1 --> Secondary[secondary: deepOrange]
    ColorScheme1 --> Background1[background: grey]
    ColorScheme1 --> Surface[surface: white]
    
    style MaterialApp2 fill:#ff9800
    style ThemeData1 fill:#ffb74d
    style ColorScheme1 fill:#ffe0b2
```

### AppColors Constants

```mermaid
graph TD
    AppColors[AppColors class]
    
    AppColors --> PrimaryColor[primary = Colors.orange]
    AppColors --> SecondaryColor[secondary = Colors.deepOrange]
    AppColors --> BgColor[background = Color 0xFFF5F5F5]
    AppColors --> CardColor[cardColor = Colors.white]
    AppColors --> TextDark[textDark = Colors.black87]
    AppColors --> TextLight[textLight = Colors.black54]
    AppColors --> SuccessColor[success = Colors.green]
    AppColors --> ErrorColor[error = Colors.red]
    AppColors --> WarningColor[warning = Colors.amber]
    
    style AppColors fill:#ff9800
```

---

## 📐 Layout Patterns

### Common Layout Pattern 1: Card Grid

```mermaid
graph TD
    GridPattern[Grid Layout Pattern]
    GridPattern --> GridView2[GridView.builder or<br/>GridView.count]
    
    GridView2 --> CrossAxis[crossAxisCount: 2]
    GridView2 --> Spacing[crossAxisSpacing: 16<br/>mainAxisSpacing: 16]
    GridView2 --> Padding3[padding: EdgeInsets.all]
    GridView2 --> Builder1[itemBuilder:<br/>returns Card]
    
    Builder1 --> Card2[Card<br/>elevation: 2<br/>shape: RoundedRectangleBorder]
    Card2 --> CardContent[Padding<br/>Column/Row layout]
    
    style GridPattern fill:#4caf50
    style GridView2 fill:#81c784
```

### Common Layout Pattern 2: List View

```mermaid
graph TD
    ListPattern[List Layout Pattern]
    ListPattern --> ListView1[ListView.builder or<br/>ListView.separated]
    
    ListView1 --> ItemCount[itemCount: data.length]
    ListView1 --> Builder2[itemBuilder:<br/>returns Widget]
    ListView1 --> Separator[separatorBuilder:<br/>returns Divider optional]
    
    Builder2 --> ListCard[Card or ListTile]
    ListCard --> Leading[leading: Icon/Image]
    ListCard --> Title4[title: Text]
    ListCard --> Subtitle[subtitle: Text]
    ListCard --> Trailing[trailing: Icon/Button]
    
    style ListPattern fill:#2196f3
    style ListView1 fill:#64b5f6
```

---

## 🔄 State Management Pattern

### setState Pattern Used

```mermaid
graph TD
    Widget1[StatefulWidget]
    Widget1 --> State1[State Object<br/>has variables]
    
    State1 --> Variables[State Variables<br/>_data: List<br/>_isLoading: bool<br/>etc.]
    State1 --> Methods[Methods]
    
    Methods --> LoadData[_loadData async]
    Methods --> HandleAction[_handleAction]
    Methods --> BuildUI[build method]
    
    LoadData --> APICall[await ApiService.call]
    APICall --> SetState[setState]
    
    SetState --> UpdateVars[Update state variables]
    UpdateVars --> Rebuild[Widget rebuilds]
    Rebuild --> UI[UI shows new data]
    
    HandleAction --> Validate[Validate input]
    Validate --> SetState2[setState _isLoading = true]
    SetState2 --> APICall2[await ApiService.action]
    APICall2 --> SetState3[setState update result]
    
    style Widget1 fill:#ff9800
    style State1 fill:#ffb74d
    style SetState fill:#4caf50
```

---

## 📱 Navigation Flow Diagram

### Complete Navigation Map

```mermaid
stateDiagram-v2
    [*] --> Splash: App starts
    
    Splash --> Login: No token
    Splash --> UserHome: Token + USER
    Splash --> RestHome: Token + RESTAURANT
    Splash --> AdminHome: Token + ADMIN
    
    Login --> Register: Sign up
    Register --> Login: Back
    
    Login --> UserHome: USER login
    Login --> RestHome: RESTAURANT login
    Login --> AdminHome: ADMIN login
    
    UserHome --> RestaurantMenu: View restaurant
    UserHome --> MyOrders: View orders
    
    RestaurantMenu --> UserHome: Back
    MyOrders --> UserHome: Back
    
    RestHome --> ManageMenu: Manage items
    RestHome --> RestOrders: View orders
    
    ManageMenu --> RestHome: Back
    RestOrders --> RestHome: Back
    
    UserHome --> Login: Logout
    RestHome --> Login: Logout
    AdminHome --> Login: Logout
```

---

This comprehensive visual guide shows every widget tree structure in the Flutter app! 🎨
