
import 'package:flutter/material.dart';
import 'package:babco/Models/DataModel.dart';
import 'package:babco/Models/MainModel.dart';
import 'package:babco/Models/RequestsModel.dart';
import 'package:babco/Models/ServicesModel.dart';
import 'package:babco/Views/ServicesReviewsPage.dart';
import 'package:babco/Views/balance_page.dart';
import 'package:babco/Views/new_service_page.dart';
import 'package:babco/Views/services_details_page.dart';
import 'package:babco/Views/services_page.dart';
import 'package:babco/Views/splashPage.dart';
import '../Views/ClientServicePage.dart';
import '../Views/PersonInformationPage.dart';
import '../Views/RequestsDetails.dart';
import '../Views/RequestsPage.dart';
import '../Views/StationMaintenancePage.dart';
import '../Views/StationReviewsPage.dart';
import '../Views/StationTransportationPage.dart';
import '../Views/about_us_page.dart';
import '../Views/contact_us_page.dart';
import '../Views/location_station.dart';
import '../Views/loyalty_page.dart';
import '../Views/map_location_page.dart';
import '../Views/map_page.dart';
import '../Views/new_offer_page.dart';
import '../Views/new_user_page.dart';
import '../Shared_Data/CompanyData.dart';
import '../Shared_Data/DelegateData.dart';
import '../Views/home_page.dart';
import '../Views/login_page.dart';
import '../Views/not_found_page.dart';
import '../Views/pay_page.dart';
import '../Views/rate_page.dart';
import '../Views/services_selected_page.dart';
import '../Views/startPage.dart';
import 'route_constants.dart';
class CustomRouter {
  static Route<dynamic> generatedRoute(RouteSettings settings) {
    switch (settings.name) {
      case startRoute:
        try {

          if (DelegateData.delegateData != null && DelegateData.delegateData?.name!= null ) {
            return MaterialPageRoute(builder: (_) => HomePage());
          }
          else {
            return MaterialPageRoute(builder: (_) => startPage());
          }
        }
        catch(e){
          return MaterialPageRoute(builder: (_) => startPage());
        }
        break;
      case loginRoute:
        {
          final args= settings.arguments as String;
          return MaterialPageRoute(builder: (_) => LoginPage(mobile:args));
        }
      case homeRoute:
        return MaterialPageRoute(builder: (_) => HomePage());
      case splashRoute:
        return MaterialPageRoute(builder: (_) => SplashPage());
      case BalanceRoute:
        return MaterialPageRoute(builder: (_) => BalancePage());
      case newUserRoute:
        return MaterialPageRoute(builder: (_) => NewUserPage());
      case NewServiceRoute:
        {
          final args= settings.arguments as DataModel;
          return MaterialPageRoute(builder: (_) => NewServicesPage(data: args,));
        }
      case mapScreenRoute:
        return MaterialPageRoute(builder: (_) => MapScreen());
      case serviceRoute:
        {
          final args= settings.arguments as String;
          return MaterialPageRoute(builder: (_) => ServicesPage(id:args));
        }
      case serviceDetailsRoute:
        {
          final args= settings.arguments as List<ServicesModel>;
          return MaterialPageRoute(builder: (_) => ServicesDetailsPage(obj: args));
        }
      case serviceSelectedPageRoute:
        {
          final args= settings.arguments as List<ServicesModel>;
          return MaterialPageRoute(builder: (_) => ServicesSelectedPage(obj: args));
        }
      case PayPageRoute:
        {
          final args= settings.arguments as List<ServicesModel>;
          return MaterialPageRoute(builder: (_) => PayPage(obj: args));
        }
        case RatePageRoute:
        {
          final args= settings.arguments as String;
          return MaterialPageRoute(builder: (_) => RatePage(obj: args));
        }
      case StationMaintenancePageRoute:
        {
          return MaterialPageRoute(builder: (_) => StationMaintenancePage());
        }
      case ClientServicePageRoute:
        {
          return MaterialPageRoute(builder: (_) => ClientServicePage());
        }
      case RequestsRoute:
        {
          return MaterialPageRoute(builder: (_) => RequestsPage());
        }
      case PersonInformationRoute:
        {
          return MaterialPageRoute(builder: (_) => PersonInformationPage());
        }
      case Connect_usRoute:
        {
          return MaterialPageRoute(builder: (_) => Connect_usPage());
        }
      case AboutUsRoute:
        {
          return MaterialPageRoute(builder: (_) => AboutUsPage());
        }
      case RequestsDetailsRoute:
        {
          final args= settings.arguments as RequestsModel;
          return MaterialPageRoute(builder: (_) => RequestsDetailsPage(obj: args));
        }
      case station_locationRoute:
        {
          return MaterialPageRoute(builder: (_) => MapLocationStationScreen());
        }
        case StationReviewsRoute:
        {
          return MaterialPageRoute(builder: (_) => StationReviewsPage());
        }
        case ServicesReviewsRoute:
        {
          return MaterialPageRoute(builder: (_) => ServicesReviewsPage());
        }
        case StationTransportationRoute:
        {
          return MaterialPageRoute(builder: (_) => StationTransportationPage());
        }
      case MapLocationRoute:
        {
          return MaterialPageRoute(builder: (_) => MapLocationScreen());
        }
        case LoyaltySystemRoute:
        {
          return MaterialPageRoute(builder: (_) => LoyaltySystemPage());
        }
        case NewOfferRoute:
        {
          final args= settings.arguments as OffersAndDiscounts;
          return MaterialPageRoute(builder: (_) => NewOfferPage(data: args,));
        }
      default:
        return MaterialPageRoute(builder: (_) => NotFoundPage());
    }
  }
}
