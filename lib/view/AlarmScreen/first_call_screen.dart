import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class FirstCallScreen extends StatefulWidget {
  const FirstCallScreen({Key? key}) : super(key: key);

  @override
  _FirstCallScreenState createState() => _FirstCallScreenState();
}

class _FirstCallScreenState extends State<FirstCallScreen> {
  bool isSecondCallScreen = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isSecondCallScreen == false
          ? firstCallScreenWidget()
          : secondCallScreenWidget(),
    );
  }

  Widget firstCallScreenWidget() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: const Color(0xff212f3c),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //
          Column(
            children: [
              //Space
              const SizedBox(
                height: 50,
              ),
              //Img
              Container(
                width: 120,
                height: 120,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  // image: DecorationImage(
                  //   fit: BoxFit.cover,
                  //   image: AssetImage("assets/images/img1.png"),
                  // ),
                ),
                child: Lottie.asset('assets/lottiee/peace-and-love.json'),
              ),
              //Space
              const SizedBox(
                height: 15,
              ),
              const Text(
                "Amritvela Gurbani",
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              //Space
              const SizedBox(
                height: 8,
              ),
              const Text(
                "Wakeup Voice Call",
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              )
            ],
          ),
          //
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  //* IF CALL REJECTED
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      //! EXIT FROM APP
                    },
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: const BoxDecoration(
                          color: Colors.black, shape: BoxShape.circle),
                      child: const Center(
                        child: Icon(
                          Icons.phone_missed_outlined,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),

                  //* IF CALL ACCEPTED
                  InkWell(
                    onTap: () {
                      setState(() {
                        // isSecondCallScreen = true;
                        //! NAVIGATE TO SECOND SCREEN
                      });
                    },
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: const BoxDecoration(
                          color: Colors.green, shape: BoxShape.circle),
                      child: const Center(
                        child: Icon(
                          Icons.phone_android,
                          size: 26,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              //Space
              const SizedBox(
                height: 25,
              ),
              Container(
                alignment: Alignment.center,
                child: const Text(
                  "swipe up to accept",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                  ),
                ),
              ),
              //Space
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget secondCallScreenWidget() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.green,
      child: Column(
        children: [
          //Space
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Icon(
                  Icons.arrow_downward,
                  color: Colors.white,
                ),
                Icon(
                  Icons.verified_user,
                  size: 20,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          //Space
          const SizedBox(
            height: 15,
          ),
          SizedBox(
            child: Container(
              child: const Text(
                "Amritvela Gurbani",
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          //Space
          const SizedBox(
            height: 8,
          ),
          const Text(
            "00:00",
            style: TextStyle(
              fontSize: 17,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          //Space
          const SizedBox(
            height: 15,
          ),
          //
          //Img
          Expanded(
            child: Container(
              width: double.infinity,
              height: 300,
              decoration: const BoxDecoration(
                color: Colors.black,
                // image: DecorationImage(
                //   fit: BoxFit.cover,
                //   image: AssetImage("assets/images/img2.jpg"),
                // ),
              ),
            ),
          ),

          //
          Column(
            children: [
              //Space
              const SizedBox(
                height: 5,
              ),
              const Icon(
                Icons.arrow_upward,
                size: 22,
                color: Colors.white,
              ),

              //Space
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Icon(
                    Icons.speaker,
                    size: 22,
                    color: Colors.white,
                  ),
                  const Icon(
                    Icons.mic,
                    size: 22,
                    color: Colors.white,
                  ),
                  const Icon(
                    Icons.video_call,
                    color: Colors.white,
                  ),
                  //
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                          color: Colors.red, shape: BoxShape.circle),
                      child: const Center(
                        child: Icon(
                          Icons.phone_android,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              //Space
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
