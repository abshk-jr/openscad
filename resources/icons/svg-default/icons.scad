$fn = 60;
width = 100;
height = 100;
paper_width = 80;
thin = 4;
thick = 10;
rounding = 2;
corner_size = 30;

list_icons = false;
selected_icon = undef;

font = "Open Sans:style=Regular";
export_font = "Open Sans:style=Bold";

icons = [
    ["export-stl"],
    ["export-off"],
    ["export-amf"],
    ["export-3mf"],
    ["export-dxf"],
    ["export-svg"],
    ["export-csg"],
    ["export-pdf"],
    ["export-png"],
    ["preview"],
    ["render"],
    ["send"],
    ["zoom-in"],
    ["zoom-out"],
    ["zoom-all"],
    ["zoom-text-in"],
    ["zoom-text-out"],
    ["undo"],
    ["redo"],
    ["indent"],
    ["unindent"],
    ["new"],
    ["save"],
    ["open"],
    ["reset-view"],
    ["view-right"],
    ["view-top"],
    ["view-bottom"],
    ["view-left"],
    ["view-front"],
    ["view-back"],
    ["perspective"],
    ["orthogonal"]
];

icon(selected_icon) {
    export("STL");
    export("OFF");
    export("AMF");
    export("3MF");
    export("DXF");
    export("SVG");
    export("CSG");
    export("PDF");
    export("PNG");
    preview();
    render_();
    send();
    zoom_in();
    zoom_out();
    zoom_all();
    zoom_text_in();
    zoom_text_out();
    undo();
    redo();
    indent();
    unindent();
    new();
    save();
    open();
    reset_view();
    view_right();
    view_top();
    view_bottom();
    view_left();
    view_front();
    view_back();
    perspective();
    orthogonal();
}

if (list_icons) {
    for (a = [ 0 : len(icons) - 1 ]) {
        echo(icon = icons[a][0]);
    }
}

module icon(icon) {
    assert(len(icons) == $children, "list of icon names needs to be same length as number of child modules to icon()");
    cnt = $children;
    cols = ceil(pow(cnt, 0.55));
    if (is_undef(icon)) {
        for (i = [0:cnt - 1]) {
            pos = 200 * [i % cols + 1, floor(i / cols) + 1];
            translate(pos) {
                %translate([width / 2, -40]) text(icons[i][0], 20, halign = "center");
                box();
                children(i);
            }
        }
    } else {
        i = search([icon], icons)[0];
        echo(i);
        children(i);
    }
}

module outline(w) {
    difference() {
        offset(w) children();
        children();
    }
}

module inset(w) {
    difference() {
        children();
        offset(delta = -w) children();
    }
}

module connect_points(cnt, pos) {
    for (idx = [0:cnt - 1]) {
        p = pos(idx);
        hull() {
            translate(p[0])
                children();
            translate(p[1])
                children();
        }
    }
}

module box(center = false) {
    module b(o, border) {
        size = width + o;
        render() difference() {
            translate([-border - o / 2, -border - o / 2]) square(size + 2 * border, center = center);
            translate([-o / 2, -o / 2]) square(size, center = center);
        }
    }

    color("black", 0.1) %b(0, rounding);
    color("red", 0.1) %b(16, rounding);
}

module paper() {
    w = rounding + thin;
    offset(rounding)
        translate([w, w])
            square([paper_width - 2 * w, height - 2 * w]);
}

module export_paper() {
    difference() {
        outline(thin) paper();
        translate([-1, height - corner_size + 1]) square([corner_size, corner_size]);
    }
    export_paper_corner();
}

module export_paper_corner() {
    translate([corner_size, height - corner_size]) {
        rotate(90) {
            hull() {
                intersection() {
                    outline(thin) paper();
                    translate([-1, -1]) square([corner_size + 1, corner_size + 1]);
                }
            }
        }
    }
}

module export(t) {
    difference() {
        translate([10, 0]) export_paper();
        translate([-20, -5]) square([height, 55]);
    }
    resize([75, 40], true)
        text(t, 40, font = export_font);
}

module hourglass() {
    module side() {
        hull() { translate([-1, 14]) circle(d = 1); translate([-7, 3]) circle(d = 1); }
        hull() { translate([-1, 14]) circle(d = 1); translate([-7, 24]) circle(d = 1); }
    }

    side();
    mirror([1, 0]) side();
    translate([0, 2]) square([18, 2], center = true);
    translate([0, 25]) square([18, 2], center = true);
    polygon([[-5, 3.5], [5, 3.5], [0.1, 6], [0.2, 14.5], [4, 21], [-4, 21], [-0.2, 14.5], [-0.1, 6]]);
}

module line(l = 40.2) {
    translate([-0.1, -0.1]) square([0.2, l]);
}

module line_dotted() {
    difference() {
        translate([-0.1, -0.1]) square([0.2, 40.2]);
        for (a = [ 0 : 2 ]) {
            translate([-5, 4 + a * 12]) square([10, 8]);
        }
    }
}

module preview_cube(size = 40) {
    offset(2) {
        children(0);
        rotate(-60) children(0);
        rotate(60) children(0);
        translate([0, size]) rotate(-60) children(0);
        translate([0, size]) rotate(60) children(0);
        translate([-sin(60) * size, cos(60) * size]) children(0);
        translate([sin(60) * size, cos(60) * size]) children(0);
        translate([-sin(60) * size, cos(60) * size + size]) rotate(-60) children(0);
        translate([sin(60) * size, cos(60) * size + size]) rotate(60) children(0);
    }
}

module render_() {
    translate([width / 2, 10]) {
        difference() {
            preview_cube() line();
            polygon([[-15, 36], [15, 36], [9, 18], [25, -10], [-25, -10], [-9, 18]]);
        }
        translate([0, -10]) scale(1.6) hourglass();
    }
}

module preview() {
    translate([width / 2, 10]) {
        difference() {
            preview_cube() line_dotted();
            translate([0, 8]) square([35, 28], center = true);
        }
        h = 14;
        translate([0, 4]) polygon([[-18, h], [-9, h], [0, 0], [-9, -h], [-18, -h], [-9, 0]]);
        translate([18, 4]) polygon([[-18, h], [-9, h], [0, 0], [-9, -h], [-18, -h], [-9, 0]]);
    }
}

module send() {
    translate([width / 2, 10]) {
        difference() {
            preview_cube() line();
            translate([0, 75]) square(40, center = true);
        }
        translate([0, 87]) offset(2) {
            rotate(180) line(30);
            rotate(150) line(15);
            rotate(210) line(15);
        }
    }
}

module zoom(r = 30) {
    children();
    difference() {
        union() {
            circle(r = r);
                rotate(210)
                    offset(thin)
                        translate([-thick/2, 0])
                            square([thick, 61]);
        }
        circle(r = r - thin);
    }
}

module cross() {
    square([thin, 32], center = true);
    square([32, thin], center = true);
}

module zoom_in() {
    r = 30;
    translate([r + thick, height - r - thick])
        zoom(r)
            cross();
}

module zoom_out() {
    r = 30;
    translate([r + thick, height - r - thick])
        zoom(r)
            square([35, thin], center = true);
}

module zoom_all() {
    r = 30;
    translate([r + thick, height - r - thick])
        zoom() {
            w = 75;
            offset(rounding) difference() {
                square(w, center = true);
                square(w - thin, center = true);
                rotate(45) square(85, center = true);
            }
        }
}

module zoom_text(angle, z) {
    text("A", 35, font = font);
    translate([40, 0]) text("A", 70, font = font);
    translate([17, z]) rotate(angle) offset(rounding) circle(14, $fn = 3);
}

module zoom_text_in() {
    zoom_text(90, 65);
}

module zoom_text_out() {
    translate([width, 0]) mirror([1, 0, 0]) zoom_text(-90, 71);
}

module curved_arrow() {
    offset(1) {
        difference() {
            circle(r = 40);
            translate([-8, 0]) circle(r = 32);
            translate([-50, -50]) square([100, 54]);
        }
    }
    translate([43, 0])
        polygon([[-35, 0], [0, 0], [0, 35]]);
}

module undo() {
    translate([width / 2, height / 3])
        mirror([1, 0, 0])
            curved_arrow();
}

module redo() {
    translate([width / 2, , height / 3])
        curved_arrow();
}

module indent_document() {
    for (a = [ 0 : 3 ]) {
        x = abs(a - 1.5) < 1 ? 30 : 0;
        translate([x, 20 * a]) square([80 - x, thick]);
    }
    offset(2) children();
}

module indent() {
    translate([thick, thick])
        indent_document()
            polygon([[2, 50], [17, 35], [2, 20]]);
}

module unindent() {
    translate([thick, thick])
        indent_document()
            polygon([[2, 35], [17, 50], [17, 20]]);
}

module new() {
    translate([10, 0]) {
        export_paper();
        translate([paper_width / 2, 2 * height / 5]) cross();
    }
}

module open() {
    module small_paper() translate([4.5,5]*u) scale(0.77) export_paper();
    module folder() {
        square([20,22]*u-[w,w]);
        translate([5.5,0]*u) square([20,19]*u-[w,w]);
    }
    module flap() translate([rounding,rounding]) offset(r=rounding) polygon([[3,0]*u, [24,0]*u, [30,12]*u, [9,12]*u]);

    u = height/32;
    w = rounding + thin;
    difference() {
      translate([rounding, rounding]) offset(r=rounding) folder();
      translate([rounding, rounding]) offset(r=rounding) offset(-w) folder();
      offset(r=rounding) hull() small_paper();
    }
    difference() {
      small_paper();
      offset(r=rounding) flap();
    }
    flap();
}

module save() {
	u = height/32;
	difference() {
		square(32*[u,u]);
		translate([4,2]*u) square([24,14]*u);
		translate([8,19]*u) square([16, 23]*u);
		translate([100,100]) rotate(45) square([8,8]*u, center=true);
	}
	translate([18,21]*u) square([4,9]*u);
	translate([6,4]*u) square([20,2]*u);
	translate([6,8]*u) square([20,2]*u);
	translate([6,12]*u) square([20,2]*u);
}

module reset_view() {
    r = 0.35 * width;
    translate([width / 2, height / 2]) {
        difference() {
            outline(thin) circle(r);
            polygon([[0, 0], [-width, -width / 2], [-width, width / 2]]);
        }
        rotate(60) translate([0, r + thin / 2]) rotate(-10)
            polygon([[-thin, 0], [thick, -thick], [thick, thick]]);
    }
}

module view_direction_cube() {
    l = 35;
    difference() {
        translate([0, l])
            polygon([[0, l / 2], [thick, -thick], [-thick, -thick]]);
        translate([0, l - 16.2])
            scale([2, 1]) circle(thick);
    }
    translate([0, -l])
        preview_cube(l)
            line(l);
}

module view_right() {
    translate([width / 2, height / 2]) {
        rotate(-90)
            view_direction_cube();
    }
}

module view_top() {
    translate([width / 2, height / 2]) {
        view_direction_cube();
    }
}

module view_bottom() {
    translate([width / 2, height / 2]) {
        rotate(180)
            view_direction_cube();
    }
}

module view_left() {
    translate([width / 2, height / 2]) {
        rotate(90)
            view_direction_cube();
    }
}

module view_front() {
    translate([width / 2, height / 2]) {
        l = 35;
        translate([0, -l]) {
            preview_cube(l)
                line(l);

            hull() {
                circle();
                translate([0, l]) circle();
                translate([-sin(60) * l, cos(60) * l]) circle();
                translate([-sin(60) * l, l + cos(60) * l]) circle();
            }
        }
    }
}

module view_back() {
    translate([width / 2, height / 2]) {
        l = 35;
        translate([0, -l])
            preview_cube(l)
                line(l);

        hull() {
            circle();
            translate([0, l]) circle();
            translate([-sin(-60) * l, cos(60) * l]) circle();
            translate([-sin(-60) * l, cos(60) * l - l]) circle();
        }
    }
}

module perspective() {
    s1 = 25;
    s2 = 5;
    o1 = [30, 30];
    o2 = [90, 90];
    p = [[-1, 1], [1, 1], [1, -1], [-1, -1]];
    connect_points(4, function(i) [o1 + s1 * p[i], o1 + s1 * p[(i + 1) % 4]]) circle(d = thin);
    connect_points(2, function(i) [o2 + s2 * p[i], o2 + s2 * p[(i + 1) % 4]]) circle(d = thin);
    connect_points(3, function(i) [o1 + s1 * p[i], o2 + s2 * p[i]]) circle(d = thin);
}

module orthogonal() {
    o1 = [40, 40];
    o2 = [60, 60];
    p = 30 * [[-1, 1], [1, 1], [1, -1], [-1, -1]];
    connect_points(4, function(i) [o1 + p[i], o1 + p[(i + 1) % 4]]) circle(d = thin);
    connect_points(4, function(i) [o2 + p[i], o2 + p[(i + 1) % 4]]) circle(d = thin);
    connect_points(4, function(i) [o1 + p[i], o2 + p[i]]) circle(d = thin);
}
