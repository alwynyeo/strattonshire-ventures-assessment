//
//  UIView+ActivityIndicator+Extension.swift
//  strattonshire-ventures-assessment
//
//  Created by Alwyn Yeo on 8/4/24.
//

import UIKit

extension UIView {

    /// An enumeration representing the different types of activity indicators.
    ///
    /// This enum is used to specify the type of activity indicator that should be displayed.
    /// It can be used to differentiate between various loading states in the application.
    enum ActivityIndicatorType {
        /// Represents a standard activity indicator, typically used for general loading scenarios.
        case normal

        /// Represents an activity indicator specifically used for pagination, indicating more content is being loaded.
        case pagination
    }

    /// Structure to define associated keys for the activity indicator view.
    private struct AssociatedKeys {
        static var activityIndicatorView = "UIView.activityIndicatorView"
    }

    /// The activity indicator view associated with the view.
    private var activityIndicatorView: UIActivityIndicatorView? {
        get {
            withUnsafePointer(to: &AssociatedKeys.activityIndicatorView) {
                return objc_getAssociatedObject(self, $0) as? UIActivityIndicatorView
            }
        }
        set {
            withUnsafePointer(to: &AssociatedKeys.activityIndicatorView) {
                objc_setAssociatedObject(
                    self,
                    $0,
                    newValue,
                    objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
                )
            }
        }
    }

    /// A computed property that indicates whether the loading animation is currently active.
    ///
    /// This property returns `true` if the activity indicator view is present in the view hierarchy,
    /// and `false` if it is not. The presence of the activity indicator view implies that
    /// a loading process is ongoing.
    var isLoading: Bool {
        return activityIndicatorView != nil
    }

    /// Starts the loading animation by adding an activity indicator view to the view.
    ///
    /// The activity indicator view based on the activity indicator type is added as a subview and centered within the view using Auto Layout constraints.
    func startLoading(for type: UIView.ActivityIndicatorType = UIView.ActivityIndicatorType.normal) {
        guard activityIndicatorView == nil else {
            return
        }

        let activityIndicatorView = createActivityIndicatorView(for: type)
        activityIndicatorView.startAnimating()

        addSubview(activityIndicatorView)

        let constraints = [
            activityIndicatorView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            activityIndicatorView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            activityIndicatorView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            activityIndicatorView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ]

        NSLayoutConstraint.activate(constraints)

        self.activityIndicatorView = activityIndicatorView
    }

    /// Stops the loading animation by removing the activity indicator view from the view.
    ///
    /// The activity indicator view is removed from the view hierarchy and deallocated.
    func stopLoading() {
        activityIndicatorView?.stopAnimating()
        activityIndicatorView?.removeFromSuperview()
        activityIndicatorView = nil
    }

    /// Creates and configures a UIActivityIndicatorView with a medium style.
    ///
    /// - Returns: A configured UIActivityIndicatorView based on the activity indicator type.
    private func createActivityIndicatorView(for type: UIView.ActivityIndicatorType = UIView.ActivityIndicatorType.normal) -> UIActivityIndicatorView {
        let style = UIActivityIndicatorView.Style.medium
        let activityIndicatorView = UIActivityIndicatorView(style: style)

        switch type {
            case .normal:
                activityIndicatorView.alpha = 1
            case .pagination:
                activityIndicatorView.alpha = 0.5
        }

        activityIndicatorView.color = Resources.Color.indicator
        activityIndicatorView.frame = bounds
        activityIndicatorView.backgroundColor = Resources.Color.backgroundColor
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false

        return activityIndicatorView
    }
}
