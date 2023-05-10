        let token = self.currentToken!
 
        if token.type == .integer {
            self.moveToken(.integer)
            guard let value = token.value, let intValue =
                    Int(value) else { fatalError("Error parsing input")
            }
            return intValue
        } else if token.type == .leftBrace {
            self.moveToken(.leftBrace)
            let result = compute()
            self.moveToken(.rightBrace)
            return result
        }
        fatalError("Error parsing input")