import '../models/vip_subscription.dart';

class VipSubscriptionService {
  static List<VipSubscription> getSubscriptions() {
    return const [
      VipSubscription(
        id: 'weekly',
        productId: 'ZaliWeekVIP',
        price: 12.99,
        currency: 'USD ',
        subtitle: '+7 Days VIP',
        isMostPopular: true,
      ),
      VipSubscription(
        id: 'monthly',
        productId: 'ZaliMonthVIP',
        price: 49.99,
        currency: 'USD ',
        subtitle: '+30 Days VIP',
      ),
    ];
  }

  static List<VipPrivilege> getPrivileges() {
    return const [
      VipPrivilege(title: 'Unlimited avatar changes'),
      VipPrivilege(title: 'Eliminate in-app advertising'),
      VipPrivilege(title: 'Unlimited Avatar list views'),
    ];
  }
}

