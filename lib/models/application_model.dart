class Application {
  final String applicationID;
  final String userId;
  final String vaid;
  final String clientId;
  final String status;
  final String tanggalPengajuan;
  final String tanggalMulai;
  final String tanggalSelesai;
  final String title;
  final String ratePrice;
  final String description;
  final String proof;

  Application({
    required this.applicationID,
    required this.userId,
    required this.vaid,
    required this.clientId,
    required this.status,
    required this.tanggalPengajuan,
    required this.tanggalMulai,
    required this.tanggalSelesai,
    required this.title,
    required this.ratePrice,
    required this.description,
    required this.proof,
  });

  factory Application.fromJson(Map<String, dynamic> json) {
    return Application(
      applicationID: '${json['ApplicationID'] ?? "0"}',
      userId: '${json['UserID'] ?? "0"}',
      vaid: '${json['Vaid'] ?? "0"}',
      clientId: '${json['ClientID'] ?? "0"}',
      status: '${json['Status'] ?? ""}',
      tanggalPengajuan: '${json['TanggalPengajuan'] ?? ""}',
      tanggalMulai: '${json['TanggalMulai'] ?? ""}',
      tanggalSelesai: '${json['TanggalSelesai'] ?? ""}',
      title: '${json['Title'] ?? ""}',
      ratePrice: '${json['RatePrice'] ?? "0"}',
      description: '${json['Description'] ?? ""}',
      proof: '${json['Proof'] ?? ""}',
    );
  }
}
