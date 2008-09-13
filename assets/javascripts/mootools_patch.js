Element.HtmlToDom = function(el, html) {
  var range = el.ownerDocument.createRange();
  range.selectNodeContents(el);
  range.collapse(true);
 
  return(range.createContextualFragment(html.stripScripts()));
}
 
Element.implement({
  replace: function(content) {
    var el = Element.HtmlToDom(this, content);    
    this.parentNode.replaceChild(el, this);
    content.stripScripts(true);
  },
  
  replaceHTML: function(content) {    
    this.set('html', content);    
    content.stripScripts(true);
  },  
  
  append: function(position, content) {
    var el = Element.HtmlToDom(this, content);
    var inserter = Element.Inserters[position];
      
    inserter(el, this);
    content.stripScripts(true);
  },
  up: function(expression, index) {
    this.getParent().getChildren(expression)[index || 0];
  },
  
  appendTop: function(content) { this.append('top', content); },
  
  appendBottom: function(content) { this.append('bottom', content); },
  
  appendAfter: function(content) { this.append('after', content); },
  
  appendBefore: function(content) { this.append('before', content); }  
});

String.implement({
  gsub: function(pattern, replacement) {
  var result = '', source = this, match;
  replacement = arguments.callee.prepareReplacement(replacement);

  while (source.length > 0) {
    if (match = source.match(pattern)) {
      result += source.slice(0, match.index);
      result += String.interpret(replacement(match));
      source  = source.slice(match.index + match[0].length);
    } else {
      result += source, source = '';
    }
  }
  return result;},
  interpret: function(value) {
    return value == null ? '' : String(value);
  },
  specialChar: {
    '\b': '\\b',
    '\t': '\\t',
    '\n': '\\n',
    '\f': '\\f',
    '\r': '\\r',
    '\\': '\\\\'
  }
});

String.prototype.gsub.prepareReplacement = function(replacement) {
  
  if ($type(replacement) == 'function') return replacement;
  var template = new Template(replacement);
  return function(match) { return template.evaluate(match) };
};


var Template = new Class({
  initialize: function(template, pattern) {
    this.template = template.toString();
    this.pattern = pattern || Template.Pattern;
  },

  evaluate: function(object) {
    
    return this.template.gsub(this.pattern, function(match) {
      if (object == null) return '';
    
      var before = match[1] || '';
      if (before == '\\') return match[2];
    
      var ctx = object;
      expr = match[3];
      var pattern = /^([^.[]+|\[((?:.*?[^\\])?)\])(\.|\[|$)/;
      match = pattern.exec(expr);
      if (match == null) return before;
    
      while (match != null) {
        var comp = (match[1].indexOf('[') == 0) ? match[2].replace('\\\\]', ']') : match[1];
        ctx = ctx[comp];
        if (null == ctx || '' == match[3]) break;
        expr = expr.substring('[' == match[3] ? match[1].length : match[0].length);
        match = pattern.exec(expr);
      }
      return before + (ctx == null) ? '' : String(ctx);
    }.bind(this));
  }
});

Template.Pattern = /(^|.|\r|\n)(#\{(.*?)\})/;

//Hash.prototype.toTemplateReplacements = Hash.prototype.toObject;

function testTemplate(template_string,object) {
  var template = new Template(template_string);
  return template.evaluate(object);
};
