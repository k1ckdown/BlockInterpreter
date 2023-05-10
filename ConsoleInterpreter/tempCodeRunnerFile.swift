        var tempDictionary: [String: String] = [:]
        let calculator = Calculate(node.value)
        let value = calculator.compare()
        if value != 0{
            for child in node.children{
                let _ = traverseTree(child)
                for (key, value) in child.dictionary{
                    if node.dictionary[key] == nil || node.dictionary[key] == "" || node.dictionary[key] == Optional(""){
                        tempDictionary.merge([key: value]){(_, new) in new}
                    } else{
                        node.dictionary[key] = value
                        tempDictionary.merge([key: value]){(_, new) in new}
                    }
                } 
                
            }
        }
        print(node.dictionary)