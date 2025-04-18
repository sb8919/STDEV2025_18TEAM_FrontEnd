class Member {
  final String name;
  final String relationship;
  final String imagePath;

  const Member({
    required this.name,
    required this.relationship,
    this.imagePath = 'assets/logo.png',
  });
}

List<Member> members = [
  const Member(
    name: '구성원1',
    relationship: '모',
  ),
  const Member(
    name: '구성원2',
    relationship: '부',
  ),
]; 