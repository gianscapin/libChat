//
//  Zone.swift
//  mobile 911
//
//  Created by Ezequiel Zarate on 21/02/2020.
//  Copyright © 2020 Soflex. All rights reserved.
//

import Foundation

public class Zone {
    var points: [Point];
    var lat: Double?;
    var lon: Double?;
    var radius: Double?;
    var type: Type?;

    init ( points: [Point] ){
        self.points = points;
        self.type = .POLYGON;
    }
    
    init ( wkt: String) {
        var wkt2 = wkt.replacingOccurrences(of: "  ", with: " ")
            .replacingOccurrences(of: "POLYGON",with: "")
            .replacingOccurrences(of: " (", with: "")
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")
            .replacingOccurrences(of: ", ", with: ",");
        
        let lonLats: [String] = wkt2.components(separatedBy: ",")
        var aux: [Point] = [];
        for x in lonLats {
            let xy = x.split(separator: " ");
            let point = Point(x: String(xy[0]), y: String(xy[1]))
            aux.append(point);
        }
        
//        self.points = [aux.count];
        self.points = aux
        self.type = .POLYGON;
    }
    
    
    func  contains(test: Point) -> Bool {
        var result = false;
        
        switch (self.type) {
        case .POLYGON?:
            result = self.inPolygon(test: test);
            break;
        case .CIRCLE?:
            break;
        case .none:
            break
        }
        
        return result;
    }
    
    
    func inPolygon(test: Point) -> Bool {
        var i: Int;
        var j: Int;
        var result = false;
        //    for (i = 0,
        //        j = points.length - 1;
        //        i < points.length;
        //        j = i++) {
        //
        //    }
        //        for var i: Int = 0, j: Int = 0; i < rawDataOut.count-3; i += 4, ++j {
        //            maskPixels[j] = rawDataOut[i + 3]
        //        }
        
        for i in 1..<self.points.count {
            let j = 1 + i
            if(j < self.points.count) {
                if ((points[i].y > test.y) != (points[j].y > test.y) &&
                    (test.x < (points[j].x - points[i].x) * (test.y - points[i].y) / (points[j].y - points[i].y) + points[i].x)) {
                    result = !result;
                }
            }
        }
        
        return result;
    }
    
    
    
    // calculos de distancia a las lineas del poligono, por si esta afuera pero cerca
    private func sqr(x: Double) -> Double {
        return x * x;
    }
    
    private func dist2(v: Point,  w: Point) -> Double {
        return sqr(x: v.x - w.x) + sqr(x: v.y - w.y);
    }
    
    private func distToSegmentSquared(  p: Point, v: Point,w: Point) -> Double {
        let l2 = dist2(v: v, w: w);
        if (l2 == 0) {
            return dist2(v: p, w: v);
        }
        let t = ((p.x - v.x) * (w.x - v.x) + (p.y - v.y) * (w.y - v.y)) / l2;
        if (t < 0) {
            return dist2(v: p, w: v);
        }
        if (t > 1) {
            return dist2(v: p, w: w);
        }
        let aux = Point(x: (v.x + t * (w.x - v.x)), y: (v.y + t * (w.y - v.y)));
        return dist2(v: p, w: aux );
    }
    
}


class Point {
    
    var x: Double = 0
    var y: Double = 0
    
    init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
    
    init(x: String, y: String) {
        self.x = Double(x) ?? 0.0
        self.y = Double(y) ?? 0.0
    }
}

enum Type {
    case POLYGON
    case CIRCLE
}
