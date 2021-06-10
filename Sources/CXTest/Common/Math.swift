extension FixedWidthInteger {
    
    internal func multipliedClamping(by rhs: Self) -> Self {
        let (value, overflow) = multipliedReportingOverflow(by: rhs)
        return overflow ? .max : value
    }
    
    internal func addingClamping(by rhs: Self) -> Self {
        let (value, overflow) = addingReportingOverflow(rhs)
        return overflow ? .max : value
    }
}
