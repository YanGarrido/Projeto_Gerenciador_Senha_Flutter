import 'package:flutter/material.dart';

class TelaInicial extends StatelessWidget {
  const TelaInicial({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.blue,
        width: 450,
        height: 64,
        child: Stack(
          children: [
            Positioned(
              left: 16,
              top: 16,
              child: Container(
                width: 343,
                height: 32,
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      top: 2,
                      child: Container(
                        width: 82.16,
                        height: 28,
                        child: Stack(
                          children: [
                            Positioned(
                              left: 0,
                              top: 0,
                              child: SizedBox(
                                width: 82.16,
                                height: 27,
                                child: Text(
                                  'PassMan',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w700,
                                    height: 1.65,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 196.58,
                      top: 16,
                      child: Container(width: 100, height: 100),
                    ),
                    Positioned(
                      left: 311,
                      top: 0,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: ShapeDecoration(
                          color: Colors.black.withValues(alpha: 0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9999),
                          ),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              left: 4,
                              top: 4,
                              child: Container(
                                width: 24,
                                height: 24,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(),
                                child: Stack(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
