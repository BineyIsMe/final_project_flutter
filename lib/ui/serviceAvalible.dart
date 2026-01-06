import 'package:flutter/material.dart';
import 'package:myapp/model/enum.dart';
import 'package:myapp/ui/widgets/serviceAvailblewidgets/serviceDismissibleItem.dart';
import 'package:myapp/ui/widgets/serviceAvailblewidgets/serviceHeader.dart';

class ServicesAvailablePage extends StatefulWidget {
  const ServicesAvailablePage({super.key});

  @override
  State<ServicesAvailablePage> createState() => _ServicesAvailablePageState();
}

class _ServicesAvailablePageState extends State<ServicesAvailablePage> {
  final List<ServiceType> _activeServices = [];
  final List<ServiceType> _inactiveServices = [];

  @override
  void initState() {
    super.initState();
    _initServices();
  }

  void _initServices() {
    for (var s in ServiceType.values) {
      _inactiveServices.add(s);
    }
  }

  void _moveToInactive(ServiceType service) {
    setState(() {
      _activeServices.remove(service);
      _inactiveServices.add(service);
    });
  }

  void _moveToActive(ServiceType service) {
    setState(() {
      _inactiveServices.remove(service);
      _activeServices.add(service);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D2D2D),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Manage Services',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Swipe items horizontally to toggle activation",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        border:
                            const Border(bottom: BorderSide(color: Colors.white)),
                      ),
                      child: Column(
                        children: [
                          const ServiceHeader(title: "Active Services", color: Colors.green),
                          Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.all(8),
                              itemCount: _activeServices.length,
                              itemBuilder: (context, index) {
                                final service = _activeServices[index];
                                return ServiceDismissibleItem(
                                  service: service,
                                  isActive: true,
                                  onDismissed: () => _moveToInactive(service),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(height: 1, color: Colors.grey[300]),
                  Expanded(
                    child: Container(
                      color: Colors.grey[50],
                      child: Column(
                        children: [
                          const ServiceHeader(title: "Inactive Services", color: Colors.grey),
                          Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.all(8),
                              itemCount: _inactiveServices.length,
                              itemBuilder: (context, index) {
                                final service = _inactiveServices[index];
                                return ServiceDismissibleItem(
                                  service: service,
                                  isActive: false,
                                  onDismissed: () => _moveToActive(service),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}