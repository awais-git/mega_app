import 'package:flutter/material.dart';

import '../helpers/helper.dart';
import '../models/option.dart';
import '../models/option_group.dart';

class OptionItemWidget extends StatefulWidget {
  final Option option;
  final OptionGroup optionGroup;
  final VoidCallback onChanged;

  OptionItemWidget({
    Key key,
    this.option,
    this.optionGroup,
    this.onChanged,
  }) : super(key: key);

  @override
  _OptionItemWidgetState createState() => _OptionItemWidgetState();
}

class _OptionItemWidgetState extends State<OptionItemWidget> with SingleTickerProviderStateMixin {
  Animation animation;
  AnimationController animationController;
  Animation<double> sizeCheckAnimation;
  Animation<double> rotateCheckAnimation;
  Animation<double> opacityAnimation;
  Animation opacityCheckAnimation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(duration: Duration(milliseconds: 350), vsync: this);
    CurvedAnimation curve = CurvedAnimation(parent: animationController, curve: Curves.easeOut);
    animation = Tween(begin: 0.0, end: 60.0).animate(curve)
      ..addListener(() {
        setState(() {});
      });
    opacityAnimation = Tween(begin: 0.0, end: 0.5).animate(curve)
      ..addListener(() {
        setState(() {});
      });
    opacityCheckAnimation = Tween(begin: 0.0, end: 1.0).animate(curve)
      ..addListener(() {
        setState(() {});
      });
    rotateCheckAnimation = Tween(begin: 2.0, end: 0.0).animate(curve)
      ..addListener(() {
        setState(() {});
      });
    sizeCheckAnimation = Tween<double>(begin: 0, end: 36).animate(curve)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        bool canChange = true;
        print(widget.optionGroup.toMap());        
        if (widget.option.checked) {// Estado pasado
          
        } else {
          if(widget.optionGroup.selected+1 > widget.optionGroup.quantity){
            canChange = false;
          }
        }
        print('canChange: '+canChange.toString());
        if(canChange){
          if (widget.option.checked) {
            animationController.reverse();
            widget.optionGroup.selected = widget.optionGroup.selected-1;
          } else {
            animationController.forward();
            widget.optionGroup.selected = widget.optionGroup.selected+1;
          }
          widget.option.checked = !widget.option.checked;
        } else {
          // Scaffold.of(context).showSnackBar(SnackBar(
          //   content: Text("Máximo a selecionar: " + widget.optionGroup.quantity.toString()),
          // ));
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Container(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Text("Sólo puede seleccionar hasta " + widget.optionGroup.quantity.toString()),
            ),
          ), backgroundColor: Colors.red.shade900, elevation: 1000, behavior: SnackBarBehavior.fixed,)
          );
        }
        widget.onChanged();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Stack(
            alignment: AlignmentDirectional.center,
            children: <Widget>[
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(60)),
                  image: DecorationImage(image: NetworkImage(widget.option.image?.thumb), fit: BoxFit.cover),
                ),
              ),
              Container(
                height: animation.value,
                width: animation.value,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(60)),
                  color: Theme.of(context).colorScheme.secondary.withOpacity(opacityAnimation.value),
                ),
                child: Transform.rotate(
                  angle: rotateCheckAnimation.value,
                  child: Icon(
                    Icons.check,
                    size: sizeCheckAnimation.value,
                    color: Theme.of(context).primaryColor.withOpacity(opacityCheckAnimation.value),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: 15),
          Flexible(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.option?.name,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      Text(
                        Helper.skipHtml(widget.option.description),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8),
                Helper.getPrice(widget.option.price, context, style: Theme.of(context).textTheme.headline4),
              ],
            ),
          )
        ],
      ),
    );
  }
}
