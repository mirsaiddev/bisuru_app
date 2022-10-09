enum PaymentType {
  user1Month,
  user3Months,
  owner1Month,
  owner3Months,
}

Map<PaymentType, String> paymentTypeNames = {
  PaymentType.user1Month: '1 Aylık Premium Kullanıcı',
  PaymentType.user3Months: '3 Aylık Premium Kullanıcı',
  PaymentType.owner1Month: '1 Aylık Premium Mağaza Sahibi ',
  PaymentType.owner3Months: '3 Aylık Premium Mağaza Sahibi ',
};
