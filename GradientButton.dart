ClipRRect(
  borderRadius: BorderRadius.circular(15),
  child: Container(
    width: 120,
    height: 50,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
        // stops: [0.0, 1.0],
        colors: _GRADIENT_COLORS[_gradientColorIndex],
      ),
    ),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        child: Align(
          alignment: Alignment.center,
          child: Text(
            "MyButton",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        onTap: _nextColor,
      ),
    ),
  ),
),
