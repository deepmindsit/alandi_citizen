import 'package:alandi/config/exported_path.dart';

class ComplaintCard extends StatelessWidget {
  final String title;
  final String location;
  final String date;
  final String status;
  final String statusColor;
  final String ticketNo;
  final String deptImg;

  const ComplaintCard({
    super.key,
    required this.title,
    required this.location,
    required this.date,
    required this.status,
    required this.statusColor,
    required this.ticketNo,
    required this.deptImg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 8,
      ),
      child: Container(
        decoration: _buildCardDecoration(),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitleRow(),
              SizedBox(height: 6),
              _buildLocationDateRow(),
              Divider(height: 16, thickness: 0.5),
              _buildTicketNumberRow(),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildCardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        width: 0.5,
        color: Colors.black.withValues(alpha: 0.2),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withAlpha(13),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  Widget _buildTitleRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Image.network(
            deptImg,
            width: 35,
            height: 35,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.error, color: Colors.red),
          ),
        ),
        SizedBox(
          width: 4,
        ),
        Expanded(
          child: CustomText(
            maxLines: 2,
            textAlign: TextAlign.start,
            title: title,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        StatusBadge(
          status: status,
          color: int.parse(statusColor),
        ),
      ],
    );
  }

  Widget _buildLocationDateRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (location.isNotEmpty) _buildLocationText(),
        _buildDateRow(),
      ],
    );
  }

  Widget _buildLocationText() {
    return Expanded(
      child: CustomText(
        textAlign: TextAlign.start,
        maxLines: 2,
        title: location,
        color: Colors.grey,
        fontSize: 12,
      ),
    );
  }

  Widget _buildDateRow() {
    return Row(
      children: [
        Icon(
          HugeIcons.strokeRoundedCalendar03,
          size: 14,
          color: Colors.grey,
        ),
        SizedBox(width: 4),
        CustomText(
          title: formatDate(date),
          color: Colors.grey,
          fontSize: 12,
        ),
      ],
    );
  }

  Widget _buildTicketNumberRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          title: "Ticket No: $ticketNo",
          color: Colors.grey,
          fontSize: 12,
        ),
        Icon(
          Icons.chevron_right,
          color: Colors.grey,
          size: 20,
        ),
      ],
    );
  }
}
