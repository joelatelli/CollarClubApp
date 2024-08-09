//
//  ModTextView.swift
//  CollarandComb
//
//  Created by Joel Muflam on 8/9/23.
//

import Foundation
import SwiftUI

enum TextView_Type {
	case h1
	case h2
	case h3
	case h4
	case h4S
	case h5
	case h5M
	case h6
	case subtitle
	case subtitleS
	case subtitle_1
	case subtitle_1B
	case subtitle_1S
	case subtitle_2
	case subtitle_2S
	case subtitle_2B
	case subtitle_2SB
	case body_1
	case body_1B
	case body_2
	case body_2B
	case body_3
	case button
	case caption
	case overline
	case overlineB
	case overlineS
}

struct ModTextView: View {
	var text: String
	var type: TextView_Type
	var lineLimit: Int = 0
	var body: some View {
		switch type {
		case .h1: return Text(text).tracking(-1.5).modifier(BarlowFont(.bold, size: 96)).lineLimit(lineLimit == 0 ? .none : lineLimit)
		case .h2: return Text(text).tracking(-0.5).modifier(BarlowFont(.bold, size: 60)).lineLimit(lineLimit == 0 ? .none : lineLimit)
		case .h3: return Text(text).tracking(0).modifier(BarlowFont(.bold, size: 48)).lineLimit(lineLimit == 0 ? .none : lineLimit)
		case .h4: return Text(text).tracking(0.25).modifier(BarlowFont(.regular, size: 34)).lineLimit(lineLimit == 0 ? .none : lineLimit)
		case .h4S: return Text(text).strikethrough(true, color: Color.text_primary_color).tracking(0.25).modifier(BarlowFont(.regular, size: 34)).lineLimit(lineLimit == 0 ? .none : lineLimit)
		case .h5: return Text(text).tracking(0).modifier(BarlowFont(.regular, size: 24)).lineLimit(lineLimit == 0 ? .none : lineLimit)
		case .h5M: return Text(text).tracking(0).modifier(BarlowFont(.medium, size: 24)).lineLimit(lineLimit == 0 ? .none : lineLimit)
		case .h6: return Text(text).tracking(0.15).modifier(BarlowFont(.regular, size: 20)).lineLimit(lineLimit == 0 ? .none : lineLimit)
		case .subtitle: return Text(text).tracking(0.15).modifier(BarlowFont(.medium, size: 18)).lineLimit(lineLimit == 0 ? .none : lineLimit)
		case .subtitleS: return Text(text).strikethrough(true, color: Color.text_primary_color).tracking(0.15).modifier(BarlowFont(.medium, size: 18)).lineLimit(lineLimit == 0 ? .none : lineLimit)
		case .subtitle_1: return Text(text).tracking(0.15).modifier(BarlowFont(.regular, size: 18)).lineLimit(lineLimit == 0 ? .none : lineLimit)
		case .subtitle_1B: return Text(text).tracking(0.15).modifier(BarlowFont(.semiBold, size: 18)).lineLimit(lineLimit == 0 ? .none : lineLimit)
		case .subtitle_1S: return Text(text).strikethrough(true, color: Color.text_primary_color).tracking(0.15).modifier(BarlowFont(.semiBold, size: 18)).lineLimit(lineLimit == 0 ? .none : lineLimit)
		case .subtitle_2: return Text(text).tracking(0.1).modifier(BarlowFont(.regular, size: 17)).lineLimit(lineLimit == 0 ? .none : lineLimit)
		case .subtitle_2S: return Text(text).strikethrough(true, color: Color.text_primary_color).tracking(0.1).modifier(BarlowFont(.medium, size: 17)).lineLimit(lineLimit == 0 ? .none : lineLimit)
		case .subtitle_2B: return Text(text).tracking(0.1).modifier(BarlowFont(.medium, size: 17)).lineLimit(lineLimit == 0 ? .none : lineLimit)
		case .subtitle_2SB: return Text(text).strikethrough(true, color: Color.text_primary_color).tracking(0.1).modifier(BarlowFont(.medium, size: 17)).lineLimit(lineLimit == 0 ? .none : lineLimit)
		case .body_1: return Text(text).tracking(0.5).modifier(BarlowFont(.regular, size: 16)).lineLimit(lineLimit == 0 ? .none : lineLimit)
		case .body_1B: return Text(text).tracking(0.5).modifier(BarlowFont(.medium, size: 16)).lineLimit(lineLimit == 0 ? .none : lineLimit)
		case .body_2: return Text(text).tracking(0.25).modifier(BarlowFont(.regular, size: 14)).lineLimit(lineLimit == 0 ? .none : lineLimit)
		case .body_2B: return Text(text).tracking(0.25).modifier(BarlowFont(.medium, size: 14)).lineLimit(lineLimit == 0 ? .none : lineLimit)
		case .body_3: return Text(text).tracking(0.25).modifier(BarlowFont(.regular, size: 14)).lineLimit(lineLimit == 1 ? 1 : lineLimit)
		case .button: return Text(text).tracking(1.25).modifier(BarlowFont(.semiBold, size: 14)).lineLimit(lineLimit == 0 ? .none : lineLimit)
		case .caption: return Text(text).tracking(0.4).modifier(BarlowFont(.medium, size: 12)).lineLimit(lineLimit == 0 ? .none : lineLimit)
		case .overline: return Text(text).tracking(1.5).modifier(BarlowFont(.semiBold, size: 10)).lineLimit(lineLimit == 0 ? .none : lineLimit)
		case .overlineB: return Text(text).tracking(1.5).modifier(BarlowFont(.bold, size: 12)).lineLimit(lineLimit == 0 ? .none : lineLimit)
		case .overlineS: return Text(text).tracking(1.5).modifier(BarlowFont(.semiBold, size: 12)).lineLimit(lineLimit == 0 ? .none : lineLimit)
		}
	}
}


