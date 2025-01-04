
    /// The highlighter responsible for handling touch interactions such as highlighting and unhighlighting the banner.
    /// - Default: `SYDefaultHighlighter`
    public var highlighter: SYBannerHighlighter? = SYDefaultHighlighter()

// MARK: - Touch

extension SYBaseBanner {
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)

        if let touch = touches.first {
            let location = touch.location(in: self)
            highlighter?.locationMoved(self, to: location)
        }
    }

    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if let touch = touches.first {
            let location = touch.location(in: self)
            highlighter?.highlight(self, at: location)
        }
    }

    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        highlighter?.stopHighlight(self)
    }

    override open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        highlighter?.stopHighlight(self)
    }
}
