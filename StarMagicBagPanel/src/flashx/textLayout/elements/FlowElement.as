package flashx.textLayout.elements
{
   import flash.events.IEventDispatcher;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   import flashx.textLayout.compose.IFlowComposer;
   import flashx.textLayout.container.ContainerController;
   import flashx.textLayout.events.ModelChange;
   import flashx.textLayout.formats.FormatValue;
   import flashx.textLayout.formats.ITextLayoutFormat;
   import flashx.textLayout.formats.TextLayoutFormat;
   import flashx.textLayout.property.Property;
   import flashx.textLayout.tlf_internal;
   
   use namespace tlf_internal;
   
   [IMXMLObject]
   public class FlowElement implements ITextLayoutFormat
   {
      private static const idString:String = "id";
      
      private static const typeNameString:String = "typeName";
      
      private static const impliedElementString:String = "impliedElement";
      
      tlf_internal static var _scratchTextLayoutFormat:TextLayoutFormat = new TextLayoutFormat();
      
      private var _parent:FlowGroupElement;
      
      private var _format:FlowValueHolder;
      
      protected var _computedFormat:TextLayoutFormat;
      
      private var _parentRelativeStart:int = 0;
      
      private var _textLength:int = 0;
      
      public function FlowElement()
      {
         super();
         if(this.abstract)
         {
            throw new Error(GlobalSettings.resourceStringFunction("invalidFlowElementConstruct"));
         }
      }
      
      tlf_internal static function createTextLayoutFormatPrototype(localStyles:ITextLayoutFormat, parentPrototype:TextLayoutFormat) : TextLayoutFormat
      {
         var parentStylesPrototype:Object = null;
         var key:String = null;
         var val:* = undefined;
         var prop:Property = null;
         var rslt:TextLayoutFormat = null;
         var noInheritParentStylesPrototype:Object = null;
         var lvh:TextLayoutFormat = null;
         var coreStyles:Object = null;
         var parentPrototypeUsable:Boolean = true;
         var hasStylesSet:Boolean = false;
         if(parentPrototype)
         {
            parentStylesPrototype = parentPrototype.tlf_internal::getStyles();
            if(parentStylesPrototype.hasNonInheritedStyles !== undefined)
            {
               if(parentStylesPrototype.hasNonInheritedStyles === true)
               {
                  noInheritParentStylesPrototype = Property.createObjectWithPrototype(parentStylesPrototype);
                  TextLayoutFormat.tlf_internal::resetModifiedNoninheritedStyles(noInheritParentStylesPrototype);
                  parentStylesPrototype.hasNonInheritedStyles = noInheritParentStylesPrototype;
                  parentStylesPrototype = noInheritParentStylesPrototype;
               }
               else
               {
                  parentStylesPrototype = parentStylesPrototype.hasNonInheritedStyles;
               }
               parentPrototypeUsable = false;
            }
         }
         else
         {
            parentPrototype = TextLayoutFormat.defaultFormat as TextLayoutFormat;
            parentStylesPrototype = parentPrototype.tlf_internal::getStyles();
         }
         var stylesObject:Object = Property.createObjectWithPrototype(parentStylesPrototype);
         var hasNonInheritedStyles:Boolean = false;
         if(localStyles != null)
         {
            lvh = localStyles as TextLayoutFormat;
            if(lvh)
            {
               coreStyles = lvh.tlf_internal::getStyles();
               for(key in coreStyles)
               {
                  val = coreStyles[key];
                  if(val == FormatValue.INHERIT)
                  {
                     if(parentPrototype)
                     {
                        prop = TextLayoutFormat.tlf_internal::description[key];
                        if(Boolean(prop) && !prop.inherited)
                        {
                           val = parentPrototype[key];
                           if(stylesObject[key] != val)
                           {
                              stylesObject[key] = val;
                              hasNonInheritedStyles = true;
                              hasStylesSet = true;
                           }
                        }
                     }
                  }
                  else if(stylesObject[key] != val)
                  {
                     prop = TextLayoutFormat.tlf_internal::description[key];
                     if(Boolean(prop) && !prop.inherited)
                     {
                        hasNonInheritedStyles = true;
                     }
                     stylesObject[key] = val;
                     hasStylesSet = true;
                  }
               }
            }
            else
            {
               for each(prop in TextLayoutFormat.tlf_internal::description)
               {
                  key = prop.name;
                  val = localStyles[key];
                  if(val !== undefined)
                  {
                     if(val == FormatValue.INHERIT)
                     {
                        if(parentPrototype)
                        {
                           if(!prop.inherited)
                           {
                              val = parentPrototype[key];
                              if(stylesObject[key] != val)
                              {
                                 stylesObject[key] = val;
                                 hasNonInheritedStyles = true;
                                 hasStylesSet = true;
                              }
                           }
                        }
                     }
                     else if(stylesObject[key] != val)
                     {
                        if(!prop.inherited)
                        {
                           hasNonInheritedStyles = true;
                        }
                        stylesObject[key] = val;
                        hasStylesSet = true;
                     }
                  }
               }
            }
         }
         if(!hasStylesSet)
         {
            if(parentPrototypeUsable)
            {
               return parentPrototype;
            }
            rslt = new TextLayoutFormat();
            rslt.tlf_internal::setStyles(stylesObject,true);
            return rslt;
         }
         if(hasNonInheritedStyles)
         {
            stylesObject.hasNonInheritedStyles = true;
            stylesObject.setPropertyIsEnumerable("hasNonInheritedStyles",false);
         }
         else if(stylesObject.hasNonInheritedStyles !== undefined)
         {
            stylesObject.hasNonInheritedStyles = undefined;
            stylesObject.setPropertyIsEnumerable("hasNonInheritedStyles",false);
         }
         rslt = new TextLayoutFormat();
         rslt.tlf_internal::setStyles(stylesObject,false);
         return rslt;
      }
      
      public function initialized(document:Object, id:String) : void
      {
         this.id = id;
      }
      
      protected function get abstract() : Boolean
      {
         return true;
      }
      
      public function get userStyles() : Object
      {
         return !!this._format ? this._format.userStyles : null;
      }
      
      public function set userStyles(styles:Object) : void
      {
         var val:String = null;
         for(val in this.userStyles)
         {
            this.setStyle(val,undefined);
         }
         for(val in styles)
         {
            if(!TextLayoutFormat.tlf_internal::description.hasOwnProperty(val))
            {
               this.setStyle(val,styles[val]);
            }
         }
      }
      
      public function get coreStyles() : Object
      {
         return !!this._format ? this._format.coreStyles : null;
      }
      
      public function get styles() : Object
      {
         return !!this._format ? this._format.styles : null;
      }
      
      tlf_internal function setStylesInternal(styles:Object) : void
      {
         if(styles)
         {
            this.tlf_internal::writableTextLayoutFormat().tlf_internal::setStyles(Property.shallowCopy(styles),false);
         }
         else if(this._format)
         {
            this._format.tlf_internal::clearStyles();
         }
         this.tlf_internal::formatChanged();
      }
      
      public function equalUserStyles(otherElement:FlowElement) : Boolean
      {
         return Property.equalStyles(this.userStyles,otherElement.userStyles,null);
      }
      
      tlf_internal function equalStylesForMerge(elem:FlowElement) : Boolean
      {
         return this.id == elem.id && this.typeName == elem.typeName && TextLayoutFormat.isEqual(elem.format,this.format);
      }
      
      public function shallowCopy(relativeStart:int = 0, relativeEnd:int = -1) : FlowElement
      {
         var retFlow:FlowElement = new (getDefinitionByName(getQualifiedClassName(this)) as Class)();
         if(this._format != null)
         {
            retFlow._format = new FlowValueHolder(this._format);
         }
         return retFlow;
      }
      
      public function deepCopy(relativeStart:int = 0, relativeEnd:int = -1) : FlowElement
      {
         if(relativeEnd == -1)
         {
            relativeEnd = this._textLength;
         }
         return this.shallowCopy(relativeStart,relativeEnd);
      }
      
      public function getText(relativeStart:int = 0, relativeEnd:int = -1, paragraphSeparator:String = "\n") : String
      {
         return "";
      }
      
      public function splitAtPosition(relativePosition:int) : FlowElement
      {
         if(relativePosition < 0 || relativePosition > this._textLength)
         {
            throw RangeError(GlobalSettings.resourceStringFunction("invalidSplitAtPosition"));
         }
         return this;
      }
      
      tlf_internal function get bindableElement() : Boolean
      {
         return this.tlf_internal::getPrivateStyle("bindable") == true;
      }
      
      tlf_internal function set bindableElement(value:Boolean) : void
      {
         this.tlf_internal::setPrivateStyle("bindable",value);
      }
      
      tlf_internal function mergeToPreviousIfPossible() : Boolean
      {
         return false;
      }
      
      tlf_internal function createContentElement() : void
      {
      }
      
      tlf_internal function releaseContentElement() : void
      {
      }
      
      public function get parent() : FlowGroupElement
      {
         return this._parent;
      }
      
      tlf_internal function setParentAndRelativeStart(newParent:FlowGroupElement, newStart:int) : void
      {
         this._parent = newParent;
         this._parentRelativeStart = newStart;
         this.tlf_internal::attributesChanged(false);
      }
      
      tlf_internal function setParentAndRelativeStartOnly(newParent:FlowGroupElement, newStart:int) : void
      {
         this._parent = newParent;
         this._parentRelativeStart = newStart;
      }
      
      public function get textLength() : int
      {
         return this._textLength;
      }
      
      tlf_internal function setTextLength(newLength:int) : void
      {
         this._textLength = newLength;
      }
      
      public function get parentRelativeStart() : int
      {
         return this._parentRelativeStart;
      }
      
      tlf_internal function setParentRelativeStart(newStart:int) : void
      {
         this._parentRelativeStart = newStart;
      }
      
      public function get parentRelativeEnd() : int
      {
         return this._parentRelativeStart + this._textLength;
      }
      
      tlf_internal function getAncestorWithContainer() : ContainerFormattedElement
      {
         var contElement:ContainerFormattedElement = null;
         var elem:FlowElement = this;
         while(elem)
         {
            contElement = elem as ContainerFormattedElement;
            if(contElement)
            {
               if(!contElement._parent || Boolean(contElement.flowComposer))
               {
                  return contElement;
               }
            }
            elem = elem._parent;
         }
         return null;
      }
      
      tlf_internal function getPrivateStyle(styleName:String) : *
      {
         return !!this._format ? this._format.getPrivateData(styleName) : undefined;
      }
      
      tlf_internal function setPrivateStyle(styleName:String, val:*) : void
      {
         if(this.tlf_internal::getPrivateStyle(styleName) != val)
         {
            this.tlf_internal::writableTextLayoutFormat().setPrivateData(styleName,val);
            this.tlf_internal::modelChanged(ModelChange.STYLE_SELECTOR_CHANGED,this,0,this._textLength);
         }
      }
      
      public function get id() : String
      {
         return this.tlf_internal::getPrivateStyle(idString);
      }
      
      public function set id(val:String) : void
      {
         return this.tlf_internal::setPrivateStyle(idString,val);
      }
      
      public function get typeName() : String
      {
         var typeName:String = this.tlf_internal::getPrivateStyle(typeNameString);
         return !!typeName ? typeName : this.tlf_internal::defaultTypeName;
      }
      
      public function set typeName(val:String) : void
      {
         if(val != this.typeName)
         {
            this.tlf_internal::setPrivateStyle(typeNameString,val == this.tlf_internal::defaultTypeName ? undefined : val);
         }
      }
      
      tlf_internal function get defaultTypeName() : String
      {
         return null;
      }
      
      tlf_internal function get impliedElement() : Boolean
      {
         return this.tlf_internal::getPrivateStyle(impliedElementString) !== undefined;
      }
      
      tlf_internal function set impliedElement(value:*) : void
      {
         this.tlf_internal::setPrivateStyle(impliedElementString,value);
      }
      
      public function get color() : *
      {
         return !!this._format ? this._format.color : undefined;
      }
      
      public function set color(colorValue:*) : void
      {
         this.tlf_internal::writableTextLayoutFormat().color = colorValue;
         this.tlf_internal::formatChanged();
      }
      
      public function get backgroundColor() : *
      {
         return !!this._format ? this._format.backgroundColor : undefined;
      }
      
      public function set backgroundColor(backgroundColorValue:*) : void
      {
         this.tlf_internal::writableTextLayoutFormat().backgroundColor = backgroundColorValue;
         this.tlf_internal::formatChanged();
      }
      
      public function get lineThrough() : *
      {
         return !!this._format ? this._format.lineThrough : undefined;
      }
      
      public function set lineThrough(lineThroughValue:*) : void
      {
         this.tlf_internal::writableTextLayoutFormat().lineThrough = lineThroughValue;
         this.tlf_internal::formatChanged();
      }
      
      public function get textAlpha() : *
      {
         return !!this._format ? this._format.textAlpha : undefined;
      }
      
      public function set textAlpha(textAlphaValue:*) : void
      {
         this.tlf_internal::writableTextLayoutFormat().textAlpha = textAlphaValue;
         this.tlf_internal::formatChanged();
      }
      
      public function get backgroundAlpha() : *
      {
         return !!this._format ? this._format.backgroundAlpha : undefined;
      }
      
      public function set backgroundAlpha(backgroundAlphaValue:*) : void
      {
         this.tlf_internal::writableTextLayoutFormat().backgroundAlpha = backgroundAlphaValue;
         this.tlf_internal::formatChanged();
      }
      
      public function get fontSize() : *
      {
         return !!this._format ? this._format.fontSize : undefined;
      }
      
      public function set fontSize(fontSizeValue:*) : void
      {
         this.tlf_internal::writableTextLayoutFormat().fontSize = fontSizeValue;
         this.tlf_internal::formatChanged();
      }
      
      public function get baselineShift() : *
      {
         return !!this._format ? this._format.baselineShift : undefined;
      }
      
      public function set baselineShift(baselineShiftValue:*) : void
      {
         this.tlf_internal::writableTextLayoutFormat().baselineShift = baselineShiftValue;
         this.tlf_internal::formatChanged();
      }
      
      public function get trackingLeft() : *
      {
         return !!this._format ? this._format.trackingLeft : undefined;
      }
      
      public function set trackingLeft(trackingLeftValue:*) : void
      {
         this.tlf_internal::writableTextLayoutFormat().trackingLeft = trackingLeftValue;
         this.tlf_internal::formatChanged();
      }
      
      public function get trackingRight() : *
      {
         return !!this._format ? this._format.trackingRight : undefined;
      }
      
      public function set trackingRight(trackingRightValue:*) : void
      {
         this.tlf_internal::writableTextLayoutFormat().trackingRight = trackingRightValue;
         this.tlf_internal::formatChanged();
      }
      
      public function get lineHeight() : *
      {
         return !!this._format ? this._format.lineHeight : undefined;
      }
      
      public function set lineHeight(lineHeightValue:*) : void
      {
         this.tlf_internal::writableTextLayoutFormat().lineHeight = lineHeightValue;
         this.tlf_internal::formatChanged();
      }
      
      public function get breakOpportunity() : *
      {
         return !!this._format ? this._format.breakOpportunity : undefined;
      }
      
      public function set breakOpportunity(breakOpportunityValue:*) : void
      {
         this.tlf_internal::writableTextLayoutFormat().breakOpportunity = breakOpportunityValue;
         this.tlf_internal::formatChanged();
      }
      
      public function get digitCase() : *
      {
         return !!this._format ? this._format.digitCase : undefined;
      }
      
      public function set digitCase(digitCaseValue:*) : void
      {
         this.tlf_internal::writableTextLayoutFormat().digitCase = digitCaseValue;
         this.tlf_internal::formatChanged();
      }
      
      public function get digitWidth() : *
      {
         return !!this._format ? this._format.digitWidth : undefined;
      }
      
      public function set digitWidth(digitWidthValue:*) : void
      {
         this.tlf_internal::writableTextLayoutFormat().digitWidth = digitWidthValue;
         this.tlf_internal::formatChanged();
      }
      
      public function get dominantBaseline() : *
      {
         return !!this._format ? this._format.dominantBaseline : undefined;
      }
      
      public function set dominantBaseline(dominantBaselineValue:*) : void
      {
         this.tlf_internal::writableTextLayoutFormat().dominantBaseline = dominantBaselineValue;
         this.tlf_internal::formatChanged();
      }
      
      public function get kerning() : *
      {
         return !!this._format ? this._format.kerning : undefined;
      }
      
      public function set kerning(kerningValue:*) : void
      {
         this.tlf_internal::writableTextLayoutFormat().kerning = kerningValue;
         this.tlf_internal::formatChanged();
      }
      
      public function get ligatureLevel() : *
      {
         return !!this._format ? this._format.ligatureLevel : undefined;
      }
      
      public function set ligatureLevel(ligatureLevelValue:*) : void
      {
         this.tlf_internal::writableTextLayoutFormat().ligatureLevel = ligatureLevelValue;
         this.tlf_internal::formatChanged();
      }
      
      public function get alignmentBaseline() : *
      {
         return !!this._format ? this._format.alignmentBaseline : undefined;
      }
      
      public function set alignmentBaseline(alignmentBaselineValue:*) : void
      {
         this.tlf_internal::writableTextLayoutFormat().alignmentBaseline = alignmentBaselineValue;
         this.tlf_internal::formatChanged();
      }
      
      public function get locale() : *
      {
         return !!this._format ? this._format.locale : undefined;
      }
      
      public function set locale(localeValue:*) : void
      {
         this.tlf_internal::writableTextLayoutFormat().locale = localeValue;
         this.tlf_internal::formatChanged();
      }
      
      public function get typographicCase() : *
      {
         return !!this._format ? this._format.typographicCase : undefined;
      }
      
      public function set typographicCase(typographicCaseValue:*) : void
      {
         this.tlf_internal::writableTextLayoutFormat().typographicCase = typographicCaseValue;
         this.tlf_internal::formatChanged();
      }
      
      public function get fontFamily() : *
      {
         return !!this._format ? this._format.fontFamily : undefined;
      }
      
      public function set fontFamily(fontFamilyValue:*) : void
      {
         this.tlf_internal::writableTextLayoutFormat().fontFamily = fontFamilyValue;
         this.tlf_internal::formatChanged();
      }
      
      public function get textDecoration() : *
      {
         return !!this._format ? this._format.textDecoration : undefined;
      }
      
      public function set textDecoration(textDecorationValue:*) : void
      {
         this.tlf_internal::writableTextLayoutFormat().textDecoration = textDecorationValue;
         this.tlf_internal::formatChanged();
      }
      
      public function get fontWeight() : *
      {
         return !!this._format ? this._format.fontWeight : undefined;
      }
      
      public function set fontWeight(fontWeightValue:*) : void
      {
         this.tlf_internal::writableTextLayoutFormat().fontWeight = fontWeightValue;
         this.tlf_internal::formatChanged();
      }
      
      public function get fontStyle() : *
      {
         return !!this._format ? this._format.fontStyle : undefined;
      }
      
      public function set fontStyle(fontStyleValue:*) : void
      {
         this.tlf_internal::writableTextLayoutFormat().fontStyle = fontStyleValue;
         this.tlf_internal::formatChanged();
      }
      
      public function get whiteSpaceCollapse() : *
      {
         return !!this._format ? this._format.whiteSpaceCollapse : undefined;
      }
      
      public function set whiteSpaceCollapse(whiteSpaceCollapseValue:*) : void
      {
         this.tlf_internal::writableTextLayoutFormat().whiteSpaceCollapse = whiteSpaceCollapseValue;
         this.tlf_internal::formatChanged();
      }
      
      public function get renderingMode() : *
      {
         return !!this._format ? this._format.renderingMode : undefined;
      }
      
      public function set renderingMode(renderingModeValue:*) : void
      {
         this.tlf_internal::writableTextLayoutFormat().renderingMode = renderingModeValue;
         this.tlf_internal::formatChanged();
      }
      
      public function get cffHinting() : *
      {
         return !!this._format ? this._format.cffHinting : undefined;
      }
      
      public function set cffHinting(cffHintingValue:*) : void
      {
         this.tlf_internal::writableTextLayoutFormat().cffHinting = cffHintingValue;
         this.tlf_internal::formatChanged();
      }
      
      public function get fontLookup() : *
      {
         return !!this._format ? this._format.fontLookup : undefined;
      }
      
      public function set fontLookup(fontLookupValue:*) : void
      {
         this.tlf_internal::writableTextLayoutFormat().fontLookup = fontLookupValue;
         this.tlf_internal::formatChanged();
      }
      
      public function get textRotation() : *
      {
         return !!this._format ? this._format.textRotation : undefined;
      }
      
      public function set textRotation(textRotationValue:*) : void
      {
         this.tlf_internal::writableTextLayoutFormat().textRotation = textRotationValue;
         this.tlf_internal::formatChanged();
      }
      
      public function get textIndent() : *
      {
         return !!this._format ? this._format.textIndent : undefined;
      }
      
      public function set textIndent(textIndentValue:*) : void
      {
         this.tlf_internal::writableTextLayoutFormat().textIndent = textIndentValue;
         this.tlf_internal::formatChanged();
      }
      
      public function get paragraphStartIndent() : *
      {
         return !!this._format ? this._format.paragraphStartIndent : undefined;
      }
      
      public function set paragraphStartIndent(paragraphStartIndentValue:*) : void
      {
         this.tlf_internal::writableTextLayoutFormat().paragraphStartIndent = paragraphStartIndentValue;
         this.tlf_internal::formatChanged();
      }
      
      public function get paragraphEndIndent() : *
      {
         return !!this._format ? this._format.paragraphEndIndent : undefined;
      }
      
      public function set paragraphEndIndent(paragraphEndIndentValue:*) : void
      {
         this.tlf_internal::writableTextLayoutFormat().paragraphEndIndent = paragraphEndIndentValue;
         this.tlf_internal::formatChanged();
      }
      
      public function get paragraphSpaceBefore() : *
      {
         return !!this._format ? this._format.paragraphSpaceBefore : undefined;
      }
      
      public function set paragraphSpaceBefore(paragraphSpaceBeforeValue:*) : void
      {
         this.tlf_internal::writableTextLayoutFormat().paragraphSpaceBefore = paragraphSpaceBeforeValue;
         this.tlf_internal::formatChanged();
      }
      
      public function get paragraphSpaceAfter() : *
      {
         return !!this._format ? this._format.paragraphSpaceAfter : undefined;
      }
      
      public function set paragraphSpaceAfter(paragraphSpaceAfterValue:*) : void
      {
         this.tlf_internal::writableTextLayoutFormat().paragraphSpaceAfter = paragraphSpaceAfterValue;
         this.tlf_internal::formatChanged();
      }
      
      public function get textAlign() : *
      {
         return !!this._format ? this._format.textAlign : undefined;
      }
      
      public function set textAlign(textAlignValue:*) : void
      {
         this.tlf_internal::writableTextLayoutFormat().textAlign = textAlignValue;
         this.tlf_internal::formatChanged();
      }
      
      public function get textAlignLast() : *
      {
         return !!this._format ? this._format.textAlignLast : undefined;
      }
      
      public function set textAlignLast(textAlignLastValue:*) : void
      {
         this.tlf_internal::writableTextLayoutFormat().textAlignLast = textAlignLastValue;
         this.tlf_internal::formatChanged();
      }
      
      public function get textJustify() : *
      {
         return !!this._format ? this._format.textJustify : undefined;
      }
      
      public function set textJustify(textJustifyValue:*) : void
      {
         this.tlf_internal::writableTextLayoutFormat().textJustify = textJustifyValue;
         this.tlf_internal::formatChanged();
      }
      
      public function get justificationRule() : *
      {
         return !!this._format ? this._format.justificationRule : undefined;
      }
      
      public function set justificationRule(justificationRuleValue:*) : void
      {
         this.tlf_internal::writableTextLayoutFormat().justificationRule = justificationRuleValue;
         this.tlf_internal::formatChanged();
      }
      
      public function get justificationStyle() : *
      {
         return !!this._format ? this._format.justificationStyle : undefined;
      }
      
      public function set justificationStyle(justificationStyleValue:*) : void
      {
         this.tlf_internal::writableTextLayoutFormat().justificationStyle = justificationStyleValue;
         this.tlf_internal::formatChanged();
      }
      
      public function get direction() : *
      {
         return !!this._format ? this._format.direction : undefined;
      }
      
      public function set direction(directionValue:*) : void
      {
         this.tlf_internal::writableTextLayoutFormat().direction = directionValue;
         this.tlf_internal::formatChanged();
      }
      
      public function get wordSpacing() : *
      {
         return !!this._format ? this._format.wordSpacing : undefined;
      }
      
      public function set wordSpacing(wordSpacingValue:*) : void
      {
         this.tlf_internal::writableTextLayoutFormat().wordSpacing = wordSpacingValue;
         this.tlf_internal::formatChanged();
      }
      
      public function get tabStops() : *
      {
         return !!this._format ? this._format.tabStops : undefined;
      }
      
      public function set tabStops(tabStopsValue:*) : void
      {
         this.tlf_internal::writableTextLayoutFormat().tabStops = tabStopsValue;
         this.tlf_internal::formatChanged();
      }
      
      public function get leadingModel() : *
      {
         return !!this._format ? this._format.leadingModel : undefined;
      }
      
      public function set leadingModel(leadingModelValue:*) : void
      {
         this.tlf_internal::writableTextLayoutFormat().leadingModel = leadingModelValue;
         this.tlf_internal::formatChanged();
      }
      
      public function get columnGap() : *
      {
         return !!this._format ? this._format.columnGap : undefined;
      }
      
      public function set columnGap(columnGapValue:*) : void
      {
         this.tlf_internal::writableTextLayoutFormat().columnGap = columnGapValue;
         this.tlf_internal::formatChanged();
      }
      
      public function get paddingLeft() : *
      {
         return !!this._format ? this._format.paddingLeft : undefined;
      }
      
      public function set paddingLeft(paddingLeftValue:*) : void
      {
         this.tlf_internal::writableTextLayoutFormat().paddingLeft = paddingLeftValue;
         this.tlf_internal::formatChanged();
      }
      
      public function get paddingTop() : *
      {
         return !!this._format ? this._format.paddingTop : undefined;
      }
      
      public function set paddingTop(paddingTopValue:*) : void
      {
         this.tlf_internal::writableTextLayoutFormat().paddingTop = paddingTopValue;
         this.tlf_internal::formatChanged();
      }
      
      public function get paddingRight() : *
      {
         return !!this._format ? this._format.paddingRight : undefined;
      }
      
      public function set paddingRight(paddingRightValue:*) : void
      {
         this.tlf_internal::writableTextLayoutFormat().paddingRight = paddingRightValue;
         this.tlf_internal::formatChanged();
      }
      
      public function get paddingBottom() : *
      {
         return !!this._format ? this._format.paddingBottom : undefined;
      }
      
      public function set paddingBottom(paddingBottomValue:*) : void
      {
         this.tlf_internal::writableTextLayoutFormat().paddingBottom = paddingBottomValue;
         this.tlf_internal::formatChanged();
      }
      
      public function get columnCount() : *
      {
         return !!this._format ? this._format.columnCount : undefined;
      }
      
      public function set columnCount(columnCountValue:*) : void
      {
         this.tlf_internal::writableTextLayoutFormat().columnCount = columnCountValue;
         this.tlf_internal::formatChanged();
      }
      
      public function get columnWidth() : *
      {
         return !!this._format ? this._format.columnWidth : undefined;
      }
      
      public function set columnWidth(columnWidthValue:*) : void
      {
         this.tlf_internal::writableTextLayoutFormat().columnWidth = columnWidthValue;
         this.tlf_internal::formatChanged();
      }
      
      public function get firstBaselineOffset() : *
      {
         return !!this._format ? this._format.firstBaselineOffset : undefined;
      }
      
      public function set firstBaselineOffset(firstBaselineOffsetValue:*) : void
      {
         this.tlf_internal::writableTextLayoutFormat().firstBaselineOffset = firstBaselineOffsetValue;
         this.tlf_internal::formatChanged();
      }
      
      public function get verticalAlign() : *
      {
         return !!this._format ? this._format.verticalAlign : undefined;
      }
      
      public function set verticalAlign(verticalAlignValue:*) : void
      {
         this.tlf_internal::writableTextLayoutFormat().verticalAlign = verticalAlignValue;
         this.tlf_internal::formatChanged();
      }
      
      public function get blockProgression() : *
      {
         return !!this._format ? this._format.blockProgression : undefined;
      }
      
      public function set blockProgression(blockProgressionValue:*) : void
      {
         this.tlf_internal::writableTextLayoutFormat().blockProgression = blockProgressionValue;
         this.tlf_internal::formatChanged();
      }
      
      public function get lineBreak() : *
      {
         return !!this._format ? this._format.lineBreak : undefined;
      }
      
      public function set lineBreak(lineBreakValue:*) : void
      {
         this.tlf_internal::writableTextLayoutFormat().lineBreak = lineBreakValue;
         this.tlf_internal::formatChanged();
      }
      
      public function get listStyleType() : *
      {
         return !!this._format ? this._format.listStyleType : undefined;
      }
      
      public function set listStyleType(listStyleTypeValue:*) : void
      {
         this.tlf_internal::writableTextLayoutFormat().listStyleType = listStyleTypeValue;
         this.tlf_internal::formatChanged();
      }
      
      public function get listStylePosition() : *
      {
         return !!this._format ? this._format.listStylePosition : undefined;
      }
      
      public function set listStylePosition(listStylePositionValue:*) : void
      {
         this.tlf_internal::writableTextLayoutFormat().listStylePosition = listStylePositionValue;
         this.tlf_internal::formatChanged();
      }
      
      public function get listAutoPadding() : *
      {
         return !!this._format ? this._format.listAutoPadding : undefined;
      }
      
      public function set listAutoPadding(listAutoPaddingValue:*) : void
      {
         this.tlf_internal::writableTextLayoutFormat().listAutoPadding = listAutoPaddingValue;
         this.tlf_internal::formatChanged();
      }
      
      public function get clearFloats() : *
      {
         return !!this._format ? this._format.clearFloats : undefined;
      }
      
      public function set clearFloats(clearFloatsValue:*) : void
      {
         this.tlf_internal::writableTextLayoutFormat().clearFloats = clearFloatsValue;
         this.tlf_internal::formatChanged();
      }
      
      public function get styleName() : *
      {
         return !!this._format ? this._format.styleName : undefined;
      }
      
      public function set styleName(styleNameValue:*) : void
      {
         this.tlf_internal::writableTextLayoutFormat().styleName = styleNameValue;
         this.tlf_internal::styleSelectorChanged();
      }
      
      public function get linkNormalFormat() : *
      {
         return !!this._format ? this._format.linkNormalFormat : undefined;
      }
      
      public function set linkNormalFormat(linkNormalFormatValue:*) : void
      {
         this.tlf_internal::writableTextLayoutFormat().linkNormalFormat = linkNormalFormatValue;
         this.tlf_internal::formatChanged();
      }
      
      public function get linkActiveFormat() : *
      {
         return !!this._format ? this._format.linkActiveFormat : undefined;
      }
      
      public function set linkActiveFormat(linkActiveFormatValue:*) : void
      {
         this.tlf_internal::writableTextLayoutFormat().linkActiveFormat = linkActiveFormatValue;
         this.tlf_internal::formatChanged();
      }
      
      public function get linkHoverFormat() : *
      {
         return !!this._format ? this._format.linkHoverFormat : undefined;
      }
      
      public function set linkHoverFormat(linkHoverFormatValue:*) : void
      {
         this.tlf_internal::writableTextLayoutFormat().linkHoverFormat = linkHoverFormatValue;
         this.tlf_internal::formatChanged();
      }
      
      public function get listMarkerFormat() : *
      {
         return !!this._format ? this._format.listMarkerFormat : undefined;
      }
      
      public function set listMarkerFormat(listMarkerFormatValue:*) : void
      {
         this.tlf_internal::writableTextLayoutFormat().listMarkerFormat = listMarkerFormatValue;
         this.tlf_internal::formatChanged();
      }
      
      public function get format() : ITextLayoutFormat
      {
         return this._format;
      }
      
      public function set format(value:ITextLayoutFormat) : void
      {
         if(value == this._format)
         {
            return;
         }
         var oldStyleName:String = this.styleName;
         if(value == null)
         {
            this._format.tlf_internal::clearStyles();
         }
         else
         {
            this.tlf_internal::writableTextLayoutFormat().copy(value);
         }
         this.tlf_internal::formatChanged();
         if(oldStyleName != this.styleName)
         {
            this.tlf_internal::styleSelectorChanged();
         }
      }
      
      tlf_internal function writableTextLayoutFormat() : FlowValueHolder
      {
         if(this._format == null)
         {
            this._format = new FlowValueHolder();
         }
         return this._format;
      }
      
      tlf_internal function formatChanged(notifyModelChanged:Boolean = true) : void
      {
         if(notifyModelChanged)
         {
            this.tlf_internal::modelChanged(ModelChange.TEXTLAYOUT_FORMAT_CHANGED,this,0,this._textLength);
         }
         this._computedFormat = null;
      }
      
      tlf_internal function styleSelectorChanged() : void
      {
         this.tlf_internal::modelChanged(ModelChange.STYLE_SELECTOR_CHANGED,this,0,this._textLength);
         this._computedFormat = null;
      }
      
      tlf_internal function get formatForCascade() : ITextLayoutFormat
      {
         var elemStyle:TextLayoutFormat = null;
         var localFormat:ITextLayoutFormat = null;
         var rslt:TextLayoutFormat = null;
         var tf:TextFlow = this.getTextFlow();
         if(tf)
         {
            elemStyle = tf.tlf_internal::getTextLayoutFormatStyle(this);
            if(elemStyle)
            {
               localFormat = this.format;
               if(localFormat == null)
               {
                  return elemStyle;
               }
               rslt = new TextLayoutFormat();
               rslt.apply(elemStyle);
               rslt.apply(localFormat);
               return rslt;
            }
         }
         return this._format;
      }
      
      public function get computedFormat() : ITextLayoutFormat
      {
         if(this._computedFormat == null)
         {
            this._computedFormat = this.tlf_internal::doComputeTextLayoutFormat();
         }
         return this._computedFormat;
      }
      
      tlf_internal function doComputeTextLayoutFormat() : TextLayoutFormat
      {
         var parentPrototype:TextLayoutFormat = !!this._parent ? TextLayoutFormat(this._parent.computedFormat) : null;
         return FlowElement.tlf_internal::createTextLayoutFormatPrototype(this.tlf_internal::formatForCascade,parentPrototype);
      }
      
      tlf_internal function attributesChanged(notifyModelChanged:Boolean = true) : void
      {
         this.tlf_internal::formatChanged(notifyModelChanged);
      }
      
      public function getStyle(styleProp:String) : *
      {
         if(TextLayoutFormat.tlf_internal::description.hasOwnProperty(styleProp))
         {
            return this.computedFormat.getStyle(styleProp);
         }
         var tf:TextFlow = this.getTextFlow();
         if(!tf || !tf.formatResolver)
         {
            return this.computedFormat.getStyle(styleProp);
         }
         return this.tlf_internal::getUserStyleWorker(styleProp);
      }
      
      tlf_internal function getUserStyleWorker(styleProp:String) : *
      {
         var userStyle:* = undefined;
         if(this._format != null)
         {
            userStyle = this._format.getStyle(styleProp);
            if(userStyle !== undefined)
            {
               return userStyle;
            }
         }
         var tf:TextFlow = this.getTextFlow();
         if(Boolean(tf) && Boolean(tf.formatResolver))
         {
            userStyle = tf.formatResolver.resolveUserFormat(this,styleProp);
            if(userStyle !== undefined)
            {
               return userStyle;
            }
         }
         return !!this._parent ? this._parent.tlf_internal::getUserStyleWorker(styleProp) : undefined;
      }
      
      public function setStyle(styleProp:String, newValue:*) : void
      {
         if(TextLayoutFormat.tlf_internal::description[styleProp])
         {
            this[styleProp] = newValue;
         }
         else
         {
            this.tlf_internal::writableTextLayoutFormat().setStyle(styleProp,newValue);
            this.tlf_internal::formatChanged();
         }
      }
      
      public function clearStyle(styleProp:String) : void
      {
         this.setStyle(styleProp,undefined);
      }
      
      tlf_internal function modelChanged(changeType:String, element:FlowElement, changeStart:int, changeLen:int, needNormalize:Boolean = true, bumpGeneration:Boolean = true) : void
      {
         var tf:TextFlow = this.getTextFlow();
         if(tf)
         {
            tf.tlf_internal::processModelChanged(changeType,element,this.getAbsoluteStart() + changeStart,changeLen,needNormalize,bumpGeneration);
         }
      }
      
      tlf_internal function appendElementsForDelayedUpdate(tf:TextFlow, changeType:String) : void
      {
      }
      
      tlf_internal function applyDelayedElementUpdate(textFlow:TextFlow, okToUnloadGraphics:Boolean, hasController:Boolean) : void
      {
      }
      
      tlf_internal function getEffectivePaddingLeft() : Number
      {
         return this.computedFormat.paddingLeft == FormatValue.AUTO ? 0 : this.computedFormat.paddingLeft;
      }
      
      tlf_internal function getEffectivePaddingRight() : Number
      {
         return this.computedFormat.paddingRight == FormatValue.AUTO ? 0 : this.computedFormat.paddingRight;
      }
      
      tlf_internal function getEffectivePaddingTop() : Number
      {
         return this.computedFormat.paddingTop == FormatValue.AUTO ? 0 : this.computedFormat.paddingTop;
      }
      
      tlf_internal function getEffectivePaddingBottom() : Number
      {
         return this.computedFormat.paddingBottom == FormatValue.AUTO ? 0 : this.computedFormat.paddingBottom;
      }
      
      public function set tracking(trackingValue:Object) : void
      {
         this.trackingRight = trackingValue;
      }
      
      tlf_internal function applyWhiteSpaceCollapse(collapse:String) : void
      {
         if(this.whiteSpaceCollapse !== undefined)
         {
            this.whiteSpaceCollapse = undefined;
         }
         this.tlf_internal::setPrivateStyle(impliedElementString,undefined);
      }
      
      public function getAbsoluteStart() : int
      {
         var rslt:int = this._parentRelativeStart;
         var elem:FlowElement = this._parent;
         while(elem)
         {
            rslt += elem._parentRelativeStart;
            elem = elem._parent;
         }
         return rslt;
      }
      
      public function getElementRelativeStart(ancestorElement:FlowElement) : int
      {
         var rslt:int = this._parentRelativeStart;
         var elem:FlowElement = this._parent;
         while(Boolean(elem) && elem != ancestorElement)
         {
            rslt += elem._parentRelativeStart;
            elem = elem._parent;
         }
         return rslt;
      }
      
      public function getTextFlow() : TextFlow
      {
         var elem:FlowElement = this;
         while(elem._parent != null)
         {
            elem = elem._parent;
         }
         return elem as TextFlow;
      }
      
      public function getParagraph() : ParagraphElement
      {
         var para:ParagraphElement = null;
         var rslt:FlowElement = this;
         while(rslt)
         {
            para = rslt as ParagraphElement;
            if(para)
            {
               break;
            }
            rslt = rslt._parent;
         }
         return para;
      }
      
      public function getParentByType(elementType:Class) : FlowElement
      {
         var curElement:FlowElement = this._parent;
         while(curElement)
         {
            if(curElement is elementType)
            {
               return curElement;
            }
            curElement = curElement._parent;
         }
         return null;
      }
      
      public function getPreviousSibling() : FlowElement
      {
         if(!this._parent)
         {
            return null;
         }
         var idx:int = this._parent.getChildIndex(this);
         return idx == 0 ? null : this._parent.getChildAt(idx - 1);
      }
      
      public function getNextSibling() : FlowElement
      {
         if(!this._parent)
         {
            return null;
         }
         var idx:int = this._parent.getChildIndex(this);
         return idx == this._parent.numChildren - 1 ? null : this._parent.getChildAt(idx + 1);
      }
      
      public function getCharAtPosition(relativePosition:int) : String
      {
         return null;
      }
      
      public function getCharCodeAtPosition(relativePosition:int) : int
      {
         var str:String = this.getCharAtPosition(relativePosition);
         return Boolean(str) && str.length > 0 ? int(str.charCodeAt(0)) : 0;
      }
      
      tlf_internal function applyFunctionToElements(func:Function) : Boolean
      {
         return func(this);
      }
      
      tlf_internal function getEventMirror() : IEventDispatcher
      {
         return null;
      }
      
      tlf_internal function hasActiveEventMirror() : Boolean
      {
         return false;
      }
      
      private function updateRange(len:int) : void
      {
         this.tlf_internal::setParentRelativeStart(this._parentRelativeStart + len);
      }
      
      tlf_internal function updateLengths(startIdx:int, len:int, updateLines:Boolean) : void
      {
         var idx:int = 0;
         var pElementCount:int = 0;
         var child:FlowElement = null;
         this.tlf_internal::setTextLength(this._textLength + len);
         var p:FlowGroupElement = this._parent;
         if(p)
         {
            idx = p.getChildIndex(this) + 1;
            pElementCount = p.numChildren;
            while(idx < pElementCount)
            {
               child = p.getChildAt(idx++);
               child.updateRange(len);
            }
            p.tlf_internal::updateLengths(startIdx,len,updateLines);
         }
      }
      
      tlf_internal function getEnclosingController(relativePos:int) : ContainerController
      {
         var textFlow:TextFlow = this.getTextFlow();
         if(textFlow == null || textFlow.flowComposer == null)
         {
            return null;
         }
         var curItem:FlowElement = this;
         while(Boolean(curItem) && (!(curItem is ContainerFormattedElement) || ContainerFormattedElement(curItem).flowComposer == null))
         {
            curItem = curItem._parent;
         }
         var flowComposer:IFlowComposer = ContainerFormattedElement(curItem).flowComposer;
         if(!flowComposer)
         {
            return null;
         }
         var controllerIndex:int = ContainerFormattedElement(curItem).flowComposer.findControllerIndexAtPosition(this.getAbsoluteStart() + relativePos,false);
         return controllerIndex != -1 ? flowComposer.getControllerAt(controllerIndex) : null;
      }
      
      tlf_internal function deleteContainerText(endPos:int, deleteTotal:int) : void
      {
         var absoluteEndPos:int = 0;
         var absStartIdx:int = 0;
         var charsDeletedFromCurContainer:int = 0;
         var enclosingController:ContainerController = null;
         var enclosingControllerBeginningPos:int = 0;
         var containerTextLengthDelta:int = 0;
         var flowComposer:IFlowComposer = null;
         var myIdx:int = 0;
         var previousEnclosingWithContent:ContainerController = null;
         if(this.getTextFlow())
         {
            absoluteEndPos = this.getAbsoluteStart() + endPos;
            absStartIdx = absoluteEndPos - deleteTotal;
            while(deleteTotal > 0)
            {
               enclosingController = this.tlf_internal::getEnclosingController(endPos - 1);
               if(!enclosingController)
               {
                  enclosingController = this.tlf_internal::getEnclosingController(endPos - deleteTotal);
                  if(enclosingController)
                  {
                     flowComposer = enclosingController.flowComposer;
                     myIdx = flowComposer.getControllerIndex(enclosingController);
                     previousEnclosingWithContent = enclosingController;
                     while(myIdx + 1 < flowComposer.numControllers && enclosingController.absoluteStart + enclosingController.textLength < endPos)
                     {
                        enclosingController = flowComposer.getControllerAt(myIdx + 1);
                        if(enclosingController.textLength)
                        {
                           previousEnclosingWithContent = enclosingController;
                           break;
                        }
                        myIdx++;
                     }
                  }
                  if(!enclosingController || !enclosingController.textLength)
                  {
                     enclosingController = previousEnclosingWithContent;
                  }
                  if(!enclosingController)
                  {
                     break;
                  }
               }
               enclosingControllerBeginningPos = enclosingController.absoluteStart;
               if(absStartIdx < enclosingControllerBeginningPos)
               {
                  charsDeletedFromCurContainer = absoluteEndPos - enclosingControllerBeginningPos + 1;
               }
               else if(absStartIdx < enclosingControllerBeginningPos + enclosingController.textLength)
               {
                  charsDeletedFromCurContainer = deleteTotal;
               }
               containerTextLengthDelta = enclosingController.textLength < charsDeletedFromCurContainer ? enclosingController.textLength : charsDeletedFromCurContainer;
               if(containerTextLengthDelta <= 0)
               {
                  break;
               }
               ContainerController(enclosingController).tlf_internal::setTextLengthOnly(enclosingController.textLength - containerTextLengthDelta);
               deleteTotal -= containerTextLengthDelta;
               absoluteEndPos -= containerTextLengthDelta;
               endPos -= containerTextLengthDelta;
            }
         }
      }
      
      tlf_internal function normalizeRange(normalizeStart:uint, normalizeEnd:uint) : void
      {
      }
      
      tlf_internal function quickCloneTextLayoutFormat(sibling:FlowElement) : void
      {
         this._format = !!sibling._format ? new FlowValueHolder(sibling._format) : null;
         this._computedFormat = null;
      }
      
      tlf_internal function updateForMustUseComposer(textFlow:TextFlow) : Boolean
      {
         return false;
      }
   }
}

