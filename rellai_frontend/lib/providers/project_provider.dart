import 'package:flutter/foundation.dart';
import 'package:rellai_frontend/models/project.dart';
import 'package:rellai_frontend/services/api/project.dart';

class ProjectProvider with ChangeNotifier {
  List<Project>? _projects;
  List<dynamic>? _invites;
  Project? _currentProject;

  List<Project>? get projects => _projects;
  List<dynamic>? get invites => _invites;
  Project? get currentProject => _currentProject;

  Future<void> updateProjects() async {
    _projects = await ProjectCRUD().fetchProjects();
    notifyListeners();
  }

  Future<void> updateCurrentProject() async {
    if (_currentProject != null) {
      _currentProject = await ProjectCRUD().fetchProject(_currentProject!.id!);
    }
    notifyListeners();
  }

  Future<void> setCurrentProject(Project project) async {
    _currentProject = project;
    notifyListeners();
  }

  Future<bool> updateInvites() async {
    _invites = await ProjectCRUD().getInvitations();
    notifyListeners();
    return true;
  }

  void clearAll() {
    _invites = null;
    _projects = null;
    _currentProject = null;
    notifyListeners();
  }
}
