class Contract {
  final String application_id;
  final String Vaid;
  final String UserID;
  final String ClientID;
  final String TanggalApprove;
  final String TanggalSelesai;
  final String Status;
  final String Rating;
  final String RatingClient;
  final String LinkFile;
  final String ApprovalClient;
  final String Alasan;

  Contract({
    required this.application_id,
    required this.Vaid,
    required this.UserID,
    required this.ClientID,
    required this.TanggalApprove,
    required this.TanggalSelesai,
    required this.Status,
    required this.Rating,
    required this.RatingClient,
    required this.LinkFile,
    required this.ApprovalClient,
    required this.Alasan,
  });

  factory Contract.fromJson(Map<String, dynamic> json) {
    return Contract(
      application_id: '${json['application_id']}',
      Vaid: '${json['Vaid']}',
      UserID: '${json['UserID']}',
      ClientID: '${json['ClientID']}',
      TanggalApprove: '${json['TanggalApprove']}',
      TanggalSelesai: '${json['TanggalSelesai']}',
      Status: '${json['Status']}',
      Rating: '${(json['Rating'] ?? 0.00).toString()}',
      RatingClient: '${(json['RatingClient'] ?? 0.00).toString()}',
      LinkFile: '${(json['LinkFile'])}',
      ApprovalClient: '${(json['ApprovalClient'])}',
      Alasan: '${(json['Alasan'])}',
    );
  }
}
