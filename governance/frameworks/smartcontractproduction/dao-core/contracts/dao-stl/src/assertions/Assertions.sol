/*
    File: Assertions.slb

    Author: Andreas Olofsson (androlo1980@gmail.com)

    Library: Assertions

    Assertions for unit testing contracts. Tests are run with the
    <solUnit at https://github.com/smartcontractproduction/sol-unit>
    unit-testing framework.

    (start code)
    contract ModAdder {

        function addMod(uint a, uint b, uint modulus) constant returns (uint sum) {
            if (modulus == 0)
                throw;
            return addmod(a, b, modulus);
        }

    }

    contract SomeTest {
        using Assertions for uint;

        function testAdd() {
            var adder = new ModAdder();
            adder.addMod(50, 66, 30).assertEqual(26, "addition returned the wrong sum");
        }
    }
    (end)

    It is also possible to extend <Test>, to have all bindings (using) properly set up.

    (start code)

    contract SomeTest is Test {

        function testAdd() {
            var adder = new ModAdder();
            adder.addMod(50, 66, 30).assertEqual(26, "addition returned the wrong sum");
        }
    }
    (end)
*/
library Assertions {

    // Constant: ADDRESS_NULL
    // The null address: 0
    address constant ADDRESS_NULL = 0;
    // Constant: BYTES32_NULL
    // The null bytes32: 0
    bytes32 constant BYTES32_NULL = 0;
    // Constant: STRING_NULL
    // The null string: ""
    string constant STRING_NULL = "";

    uint8 constant ZERO = uint8(byte('0'));
    uint8 constant A = uint8(byte('a'));

    byte constant MINUS = byte('-');
    byte constant SPACE = byte(' ');

    /*
        Event: TestEvent

        Fired when an assertion is made.

        Params:
            result (bool) - Whether or not the assertion holds.
            message (string) - A message to display if the assertion does not hold.
    */
    event TestEvent(bool indexed result, string message);

    // ************************************** strings **************************************

    /*
        Function: assertEqual(string)

        Assert that two strings are equal.

        : _stringsEqual(A, B) == true

        Params:
            A (string) - The first string.
            B (string) - The second string.
            message (string) - A message that is sent if the assertion fails.

        Returns:
            result (bool) - The result.
    */
    function assertEqual(string A, string B, string message) constant returns (bool result) {
        result = _stringsEqual(A, B);
        if (result)
            _report(result, message);
        else
            _report(result, _appendTagged(_tag(A, "Tested"), _tag(B, "Against"), message));
    }

    /*
        Function: assertNotEqual(string)

        Assert that two strings are not equal.

        : _stringsEqual(A, B) == false

        Params:
            A (string) - The first string.
            B (string) - The second string.
            message (string) - A message that is sent if the assertion fails.

        Returns:
            result (bool) - The result.
    */
    function assertNotEqual(string A, string B, string message) constant returns (bool result) {
        result = !_stringsEqual(A, B);
        if (result)
            _report(result, message);
        else
            _report(result, _appendTagged(_tag(A, "Tested"), _tag(B, "Against"), message));
    }

    /*
        Function: assertEmpty(string)

        Assert that a string is empty.

        : _stringsEqual(str, STRING_NULL) == true

        Params:
            str (string) - The string.
            message (string) - A message that is sent if the assertion fails.

        Returns:
            result (bool) - The result.
    */
    function assertEmpty(string str, string message) constant returns (bool result) {
        result = _stringsEqual(str, STRING_NULL);
        if (result)
            _report(result, message);
        else
            _report(result, _appendTagged(_tag(str, "Tested"), message));
    }

    /*
        Function: assertNotEmpty(string)

        Assert that a string is not empty.

        : _stringsEqual(str, STRING_NULL) == false

        Params:
            str (string) - The string.
            message (string) - A message that is sent if the assertion fails.

        Returns:
            result (bool) - The result.
    */
    function assertNotEmpty(string str, string message) constant returns (bool result) {
        result = !_stringsEqual(str, STRING_NULL);
        if (result)
            _report(result, message);
        else
            _report(result, _appendTagged(_tag(str, "Tested"), message));
    }

    // ************************************** bytes32 **************************************

    /*
        Function: assertEqual(bytes32)

        Assert that two 'bytes32' are equal.

        : A == B

        Params:
            A (bytes32) - The first 'bytes32'.
            B (bytes32) - The second 'bytes32'.
            message (string) - A message that is sent if the assertion fails.

        Returns:
            result (bool) - The result.
    */
    function assertEqual(bytes32 A, bytes32 B, string message) constant returns (bool result) {
        result = (A == B);
        _report(result, message);
    }

    /*
        Function: assertNotEqual(bytes32)

        Assert that two 'bytes32' are not equal.

        : A != B

        Params:
            A (bytes32) - The first 'bytes32'.
            B (bytes32) - The second 'bytes32'.
            message (string) - A message that is sent if the assertion fails.

        Returns:
            result (bool) - The result.
    */
    function assertNotEqual(bytes32 A, bytes32 B, string message) constant returns (bool result) {
        result = (A != B);
        _report(result, message);
    }

    /*
        Function: assertZero(bytes32)

        Assert that a 'bytes32' is zero.

        : bts == BYTES32_NULL

        Params:
            bts (bytes32) - The 'bytes32'.
            message (string) - A message that is sent if the assertion fails.

        Returns:
            result (bool) - The result.
    */
    function assertZero(bytes32 bts, string message) constant returns (bool result) {
        result = (bts == BYTES32_NULL);
        _report(result, message);
    }

    /*
        Function: assertNotZero(bytes32)

        Assert that a 'bytes32' is not zero.

        : bts != BYTES32_NULL

        Params:
            bts (bytes32) - The 'bytes32'.
            message (string) - A message that is sent if the assertion fails.

        Returns:
            result (bool) - The result.
    */
    function assertNotZero(bytes32 bts, string message) constant returns (bool result) {
        result = (bts != BYTES32_NULL);
        _report(result, message);
    }

    // ************************************** address **************************************

    /*
        Function: assertEqual(address)

        Assert that two addresses are equal.

        : A == B

        Params:
            A (address) - The first address.
            B (address) - The second address.
            message (string) - A message that is sent if the assertion fails.

        Returns:
            result (bool) - The result.
    */
    function assertEqual(address A, address B, string message) constant returns (bool result) {
        result = (A == B);
        _report(result, message);
    }
    /*
        Function: assertNotEqual(address)

        Assert that two addresses are not equal.

        : A != B

        Params:
            A (address) - The first address.
            B (address) - The second address.
            message (string) - A message that is sent if the assertion fails.

        Returns:
            result (bool) - The result.
    */
    function assertNotEqual(address A, address B, string message) constant returns (bool result) {
        result = (A != B);
         _report(result, message);
    }

    /*
        Function: assertZero(address)

        Assert that an address is zero.

        : addr == ADDRESS_NULL

        Params:
            addr (address) - The address.
            message (string) - A message that is sent if the assertion fails.

        Returns:
            result (bool) - The result.
    */
    function assertZero(address addr, string message) constant returns (bool result) {
        result = (addr == ADDRESS_NULL);
        _report(result, message);
    }

    /*
        Function: assertNotZero(address)

        Assert that an address is not zero.

        : addr != ADDRESS_NULL

        Params:
            addr (address) - The address.
            message (string) - A message that is sent if the assertion fails.

        Returns:
            result (bool) - The result.
    */
    function assertNotZero(address addr, string message) constant returns (bool result) {
        result = (addr != ADDRESS_NULL);
        _report(result, message);
    }

    // ************************************** bool **************************************

    /*
        Function: assertTrue

        Assert that a boolean is 'true'.

        : b == true

        Params:
            b (bool) - The boolean.
            message (string) - A message that is sent if the assertion fails.

        Returns:
            result (bool) - The result.
    */
    function assertTrue(bool b, string message) constant returns (bool result) {
        result = b;
        _report(result, message);
    }

    /*
        Function: assert

        Shorthand for 'assertTrue'

        : b == true

        Params:
            b (bool) - The boolean.
            message (string) - A message that is sent if the assertion fails.

        Returns:
            result (bool) - The result.
    */
    function assert(bool b, string message) constant returns (bool result) {
        result = b;
        _report(result, message);
    }

    /*
        Function: assertFalse

        Assert that a boolean is 'false'.

        : b == false

        Params:
            b (bool) - The boolean.
            message (string) - A message that is sent if the assertion fails.

        Returns:
            result (bool) - The result.
    */
    function assertFalse(bool b, string message) constant returns (bool result) {
        result = !b;
        _report(result, message);
    }

    /*
        Function: assertEqual(bool)

        Assert that two booleans are equal.

        : A == B

        Params:
            A (bool) - The first boolean.
            B (bool) - The second boolean.
            message (string) - A message that is sent if the assertion fails.

        Returns:
            result (bool) - The result.
    */
    function assertEqual(bool A, bool B, string message) constant returns (bool result) {
        result = (A == B);
        if (result)
            _report(result, message);
        else
            _report(result, _appendTagged(_tag(A, "Tested"), _tag(B, "Against"), message));
    }

    /*
        Function: assertNotEqual(bool)

        Assert that two booleans are not equal.

        : A != B

        Params:
            A (bool) - The first boolean.
            B (bool) - The second boolean.
            message (string) - A message that is sent if the assertion fails.

        Returns:
            result (bool) - The result.
    */
    function assertNotEqual(bool A, bool B, string message) constant returns (bool result) {
        result = (A != B);
        if (result)
            _report(result, message);
        else
            _report(result, _appendTagged(_tag(A, "Tested"), _tag(B, "Against"), message));
    }

    // ************************************** uint **************************************

    /*
        Function: assertEqual(uint)

        Assert that two (256 bit) unsigned integers are equal.

        : A == B

        Params:
            A (uint) - The first uint.
            B (uint) - The second uint.
            message (string) - A message that is sent if the assertion fails.

        Returns:
            result (bool) - The result.
    */
    function assertEqual(uint A, uint B, string message) constant returns (bool result) {
        result = (A == B);
        if (result)
            _report(result, message);
        else
            _report(result, _appendTagged(_tag(A, "Tested"), _tag(B, "Against"), message));
    }

    /*
        Function: assertNotEqual(uint)

        Assert that two (256 bit) unsigned integers are not equal.

        : A != B

        Params:
            A (uint) - The first uint.
            B (uint) - The second uint.
            message (string) - A message that is sent if the assertion fails.

        Returns:
            result (bool) - The result.
    */
    function assertNotEqual(uint A, uint B, string message) constant returns (bool result) {
        result = (A != B);
        if (result)
            _report(result, message);
        else
            _report(result, _appendTagged(_tag(A, "Tested"), _tag(B, "Against"), message));
    }

    /*
        Function: assertGT(uint)

        Assert that the uint 'A' is greater than the uint 'B'.

        : A > B

        Params:
            A (uint) - The first uint.
            B (uint) - The second uint.
            message (string) - A message that is sent if the assertion fails.

        Returns:
            result (bool) - The result.
    */
    function assertGT(uint A, uint B, string message) constant returns (bool result) {
        result = (A > B);
        if (result)
            _report(result, message);
        else
            _report(result, _appendTagged(_tag(A, "Tested"), _tag(B, "Against"), message));
    }

    /*
        Function: assertGTOE(uint)

        Assert that the uint 'A' is greater than or equal to the uint 'B'.

        : A >= B

        Params:
            A (uint) - The first uint.
            B (uint) - The second uint.
            message (string) - A message that is sent if the assertion fails.

        Returns:
            result (bool) - The result.
    */
    function assertGTOE(uint A, uint B, string message) constant returns (bool result) {
        result = (A >= B);
        if (result)
            _report(result, message);
        else
            _report(result, _appendTagged(_tag(A, "Tested"), _tag(B, "Against"), message));
    }

    /*
        Function: assertLT(uint)

        Assert that the uint 'A' is lesser than the uint 'B'.

        : A < B

        Params:
            A (uint) - The first uint.
            B (uint) - The second uint.
            message (string) - A message that is sent if the assertion fails.

        Returns:
            result (bool) - The result.
    */
    function assertLT(uint A, uint B, string message) constant returns (bool result) {
        result = (A < B);
        if (result)
            _report(result, message);
        else
            _report(result, _appendTagged(_tag(A, "Tested"), _tag(B, "Against"), message));
    }

    /*
        Function: assertLTOE(uint)

        Assert that the uint 'A' is lesser than or equal to the uint 'B'.

        : A <= B

        Params:
            A (uint) - The first uint.
            B (uint) - The second uint.
            message (string) - A message that is sent if the assertion fails.

        Returns:
            result (bool) - The result.
    */
    function assertLTOE(uint A, uint B, string message) constant returns (bool result) {
        result = (A <= B);
        if (result)
            _report(result, message);
        else
            _report(result, _appendTagged(_tag(A, "Tested"), _tag(B, "Against"), message));
    }

    /*
        Function: assertZero(uint)

        Assert that a (256 bit) unsigned integer is 0.

        : number == 0

        Params:
            number (uint) - The uint.
            message (string) - A message that is sent if the assertion fails.

        Returns:
            result (bool) - The result.
    */
    function assertZero(uint number, string message) constant returns (bool result) {
        result = (number == 0);
        if (result)
            _report(result, message);
        else
            _report(result, _appendTagged(_tag(number, "Tested"), message));
    }

    /*
        Function: assertNotZero(uint)

        Assert that a (256 bit) unsigned integer is not 0.

        : number != 0

        Params:
            number (uint) - The uint.
            message (string) - A message that is sent if the assertion fails.

        Returns:
            result (bool) - The result.
    */
    function assertNotZero(uint number, string message) constant returns (bool result) {
        result = (number != 0);
        if (result)
            _report(result, message);
        else
            _report(result, _appendTagged(_tag(number, "Tested"), message));
    }

    // ************************************** int **************************************

    /*
        Function: assertEqual(int)

        Assert that two (256 bit) signed integers are equal.

        : A == B

        Params:
            A (int) - The first int.
            B (int) - The second int.
            message (string) - A message that is sent if the assertion fails.

        Returns:
            result (bool) - The result.
    */
    function assertEqual(int A, int B, string message) constant returns (bool result) {
        result = (A == B);
        if (result)
            _report(result, message);
        else
            _report(result, _appendTagged(_tag(A, "Tested"), _tag(B, "Against"), message));
    }

    /*
        Function: assertNotEqual(int)

        Assert that two (256 bit) signed integers are not equal.

        : A != B

        Params:
            A (int) - The first int.
            B (int) - The second int.
            message (string) - A message that is sent if the assertion fails.

        Returns:
            result (bool) - The result.
    */
    function assertNotEqual(int A, int B, string message) constant returns (bool result) {
        result = (A != B);
        if (result)
            _report(result, message);
        else
            _report(result, _appendTagged(_tag(A, "Tested"), _tag(B, "Against"), message));
    }

    /*
        Function: assertGT(int)

        Assert that the int 'A' is greater than the int 'B'.

        : A > B

        Params:
            A (int) - The first int.
            B (int) - The second int.
            message (string) - A message that is sent if the assertion fails.

        Returns:
            result (bool) - The result.
    */
    function assertGT(int A, int B, string message) constant returns (bool result) {
        result = (A > B);
        if (result)
            _report(result, message);
        else
            _report(result, _appendTagged(_tag(A, "Tested"), _tag(B, "Against"), message));
    }

    /*
        Function: assertGTOE(int)

        Assert that the int 'A' is greater than or equal to the int 'B'.

        : A >= B

        Params:
            A (int) - The first int.
            B (int) - The second int.
            message (string) - A message that is sent if the assertion fails.

        Returns:
            result (bool) - The result.
    */
    function assertGTOE(int A, int B, string message) constant returns (bool result) {
        result = (A >= B);
        if (result)
            _report(result, message);
        else
            _report(result, _appendTagged(_tag(A, "Tested"), _tag(B, "Against"), message));
    }

    /*
        Function: assertLT(int)

        Assert that the int 'A' is lesser than the int 'B'.

        : A < B

        Params:
            A (int) - The first int.
            B (int) - The second int.
            message (string) - A message that is sent if the assertion fails.

        Returns:
            result (bool) - The result.
    */
    function assertLT(int A, int B, string message) constant returns (bool result) {
        result = (A < B);
        if (result)
            _report(result, message);
        else
            _report(result, _appendTagged(_tag(A, "Tested"), _tag(B, "Against"), message));
    }

    /*
        Function: assertLTOE(int)

        Assert that the int 'A' is lesser than or equal to the int 'B'.

        : A <= B

        Params:
            A (int) - The first int.
            B (int) - The second int.
            message (string) - A message that is sent if the assertion fails.

        Returns:
            result (bool) - The result.
    */
    function assertLTOE(int A, int B, string message) constant returns (bool result) {
        result = (A <= B);
        if (result)
            _report(result, message);
        else
            _report(result, _appendTagged(_tag(A, "Tested"), _tag(B, "Against"), message));
    }

    /*
        Function: assertZero(int)

        Assert that a (256 bit) signed integer is 0.

        : number == 0

        Params:
            number (int) - The int.
            message (string) - A message that is sent if the assertion fails.

        Returns:
            result (bool) - The result.
    */
    function assertZero(int number, string message) constant returns (bool result) {
        result = (number == 0);
        if (result)
            _report(result, message);
        else
            _report(result, _appendTagged(_tag(number, "Tested"), message));
    }

    /*
        Function: assertNotZero(int)

        Assert that a (256 bit) signed integer is not 0.

        : number != 0

        Params:
            number (int) - The int.
            message (string) - A message that is sent if the assertion fails.

        Returns:
            result (bool) - The result.
    */
    function assertNotZero(int number, string message) constant returns (bool result) {
        result = (number != 0);
        if (result)
            _report(result, message);
        else
            _report(result, _appendTagged(_tag(number, "Tested"), message));
    }

    // ************************************** uint[] **************************************

    /*
        Function: assertEqual(uint[])

        Assert that two 'uint[ ]' are equal.

        : arrA.length == arrB.length

        and, for all valid indices 'i'

        : arrA[i] == arrB[i]

        Params:
            A (uint[]) - The first array.
            B (uint[]) - The second array.
            message (string) - A message that is sent if the assertion fails.

        Returns:
            result (bool) - The result.
    */
    function assertEqual(uint[] arrA, uint[] arrB, string message) constant returns (bool result) {
        result = arrA.length == arrB.length;
        if (result) {
            for (uint i = 0; i < arrA.length; i++) {
                if (arrA[i] != arrB[i]) {
                    result = false;
                    break;
                }
            }
        }
        _report(result, message);
    }

    /*
        Function: assertNotEqual(uint[])

        Assert that two 'uint[]' are not equal.

        : arrA.length != arrB.length

        or, for some valid index 'i'

        : arrA[i] != arrB[i]

        Params:
            A (uint[]) - The first string.
            B (uint[]) - The second string.
            message (string) - A message that is sent if the assertion fails.

        Returns:
            result (bool) - The result.
    */
    function assertNotEqual(uint[] arrA, uint[] arrB, string message) constant returns (bool result) {
        var r = arrA.length == arrB.length;
        if (r) {
            for (uint i = 0; i < arrA.length; i++) {
                if (arrA[i] == arrB[i]) {
                    r = true;
                    break;
                }
            }
        }
        _report(!r, message);
    }

    /*
        Function: assertLengthEqual(uint[])

        Assert that the length of a 'uint[]' is equal to a given value.

        : arr.length == length

        Params:
            arr (uint[]) - The array.
            length (uint) - The length.
            message (string) - A message that is sent if the assertion fails.

        Returns:
            result (bool) - The result.
    */
    function assertLengthEqual(uint[] arr, uint length, string message) constant returns (bool result) {
        uint arrLength = arr.length;
        if (arrLength == length)
            _report(result, "");
        else
            _report(result, _appendTagged(_tag(arrLength, "Tested"), _tag(length, "Against"), message));
    }

    /*
        Function: assertLengthNotEqual(uint[])

        Assert that the length of a 'uint[]' is not equal to a given value.

        : arr.length != length

        Params:
            arr (uint[]) - The array.
            length (uint) - The length.
            message (string) - A message that is sent if the assertion fails.

        Returns:
            result (bool) - The result.
    */
    function assertLengthNotEqual(uint[] arr, uint length, string message) constant returns (bool result) {
        uint arrLength = arr.length;
        if (arrLength != arr.length)
            _report(result, "");
        else
            _report(result, _appendTagged(_tag(arrLength, "Tested"), _tag(length, "Against"), message));
    }

    // ************************************** int[] **************************************

    /*
        Function: assertEqual(int[])

        Assert that two 'int[]' are equal.

        : arrA.length == arrB.length

        and, for all valid indices 'i'

        : arrA[i] == arrB[i]

        Params:
            A (int[]) - The first array.
            B (int[]) - The second array.
            message (string) - A message that is sent if the assertion fails.

        Returns:
            result (bool) - The result.
    */
    function assertEqual(int[] arrA, int[] arrB, string message) constant returns (bool result) {
        result = arrA.length == arrB.length;
        if (result) {
            for (uint i = 0; i < arrA.length; i++) {
                if (arrA[i] != arrB[i]) {
                    result = false;
                    break;
                }
            }
        }
        _report(result, message);
    }

    /*
        Function: assertNotEqual(int[])

        Assert that two 'int[]' are not equal.

        : arrA.length != arrB.length

        or, for some valid index 'i'

        : arrA[i] != arrB[i]

        Params:
            A (int[]) - The first string.
            B (int[]) - The second string.
            message (string) - A message that is sent if the assertion fails.

        Returns:
            result (bool) - The result.
    */
    function assertNotEqual(int[] arrA, int[] arrB, string message) constant returns (bool result) {
        var r = arrA.length == arrB.length;
        if (r) {
            for (uint i = 0; i < arrA.length; i++) {
                if (arrA[i] == arrB[i]) {
                    r = true;
                    break;
                }
            }
        }
        _report(!r, message);
    }

    /*
        Function: assertLengthEqual(int[])

        Assert that the length of an 'int[]' is equal to a given value.

        : arr.length == length

        Params:
            arr (int[]) - The array.
            length (uint) - The length.
            message (string) - A message that is sent if the assertion fails.

        Returns:
            result (bool) - The result.
    */
    function assertLengthEqual(int[] arr, uint length, string message) constant returns (bool result) {
        uint arrLength = arr.length;
        if (arrLength == length)
            _report(result, "");
        else
            _report(result, _appendTagged(_tag(arrLength, "Tested"), _tag(length, "Against"), message));
    }

    /*
        Function: assertLengthNotEqual(int[])

        Assert that the length of an 'int[]' is not equal to a given value.

        : arr.length != length

        Params:
            arr (int[]) - The array.
            length (uint) - The length.
            message (string) - A message that is sent if the assertion fails.

        Returns:
            result (bool) - The result.
    */
    function assertLengthNotEqual(int[] arr, uint length, string message) constant returns (bool result) {
        uint arrLength = arr.length;
        if (arrLength != arr.length)
            _report(result, "");
        else
            _report(result, _appendTagged(_tag(arrLength, "Tested"), _tag(length, "Against"), message));
    }
    
    // ************************************** address[] **************************************

    /*
        Function: assertEqual(address[])

        Assert that two 'address[]' are equal.

        : arrA.length == arrB.length

        and, for all valid indices 'i'

        : arrA[i] == arrB[i]

        Params:
            A (address[]) - The first array.
            B (address[]) - The second array.
            message (string) - A message that is sent if the assertion fails.

        Returns:
            result (bool) - The result.
    */
    function assertEqual(address[] arrA, address[] arrB, string message) constant returns (bool result) {
        result = arrA.length == arrB.length;
        if (result) {
            for (uint i = 0; i < arrA.length; i++) {
                if (arrA[i] != arrB[i]) {
                    result = false;
                    break;
                }
            }
        }
        _report(result, message);
    }

    /*
        Function: assertNotEqual(address[])

        Assert that two 'address[]' are not equal.

        : arrA.length != arrB.length

        or, for some valid index 'i'

        : arrA[i] != arrB[i]

        Params:
            A (address[]) - The first string.
            B (address[]) - The second string.
            message (string) - A message that is sent if the assertion fails.

        Returns:
            result (bool) - The result.
    */
    function assertNotEqual(address[] arrA, address[] arrB, string message) constant returns (bool result) {
        var r = arrA.length == arrB.length;
        if (r) {
            for (uint i = 0; i < arrA.length; i++) {
                if (arrA[i] == arrB[i]) {
                    r = true;
                    break;
                }
            }
        }
        _report(!r, message);
    }

    /*
        Function: assertLengthEqual(address[])

        Assert that the length of an 'address[]' is equal to a given value.

        : arr.length == length

        Params:
            arr (address[]) - The array.
            length (uint) - The length.
            message (string) - A message that is sent if the assertion fails.

        Returns:
            result (bool) - The result.
    */
    function assertLengthEqual(address[] arr, uint length, string message) constant returns (bool result) {
        uint arrLength = arr.length;
        if (arrLength == length)
            _report(result, "");
        else
            _report(result, _appendTagged(_tag(arrLength, "Tested"), _tag(length, "Against"), message));
    }

    /*
        Function: assertLengthNotEqual(address[])

        Assert that the length of an 'address[]' is not equal to a given value.

        : arr.length != length

        Params:
            arr (address[]) - The array.
            length (uint) - The length.
            message (string) - A message that is sent if the assertion fails.

        Returns:
            result (bool) - The result.
    */
    function assertLengthNotEqual(address[] arr, uint length, string message) constant returns (bool result) {
        uint arrLength = arr.length;
        if (arrLength != arr.length)
            _report(result, "");
        else
            _report(result, _appendTagged(_tag(arrLength, "Tested"), _tag(length, "Against"), message));
    }

    // ************************************** bytes32[] **************************************

    /*
        Function: assertEqual(bytes32[])

        Assert that two 'bytes32[]' are equal.

        : arrA.length == arrB.length

        and, for all valid indices 'i'

        : arrA[i] == arrB[i]

        Params:
            A (bytes32[]) - The first array.
            B (bytes32[]) - The second array.
            message (string) - A message that is sent if the assertion fails.

        Returns:
            result (bool) - The result.
    */
    function assertEqual(bytes32[] arrA, bytes32[] arrB, string message) constant returns (bool result) {
        result = arrA.length == arrB.length;
        if (result) {
            for (uint i = 0; i < arrA.length; i++) {
                if (arrA[i] != arrB[i]) {
                    result = false;
                    break;
                }
            }
        }
        _report(result, message);
    }

    /*
        Function: assertNotEqual(bytes32[])

        Assert that two 'bytes32[]' are not equal.

        : arrA.length != arrB.length

        or, for some valid index 'i'

        : arrA[i] != arrB[i]

        Params:
            A (bytes32[]) - The first string.
            B (bytes32[]) - The second string.
            message (string) - A message that is sent if the assertion fails.

        Returns:
            result (bool) - The result.
    */
    function assertNotEqual(bytes32[] arrA, bytes32[] arrB, string message) constant returns (bool result) {
        var r = arrA.length == arrB.length;
        if (r) {
            for (uint i = 0; i < arrA.length; i++) {
                if (arrA[i] == arrB[i]) {
                    r = true;
                    break;
                }
            }
        }
        _report(!r, message);
    }

    /*
        Function: assertLengthEqual(bytes32[])

        Assert that the length of an 'bytes32[]' is equal to a given value.

        : arr.length == length

        Params:
            arr (bytes32[]) - The array.
            length (uint) - The length.
            message (string) - A message that is sent if the assertion fails.

        Returns:
            result (bool) - The result.
    */
    function assertLengthEqual(bytes32[] arr, uint length, string message) constant returns (bool result) {
        uint arrLength = arr.length;
        if (arrLength == length)
            _report(result, "");
        else
            _report(result, _appendTagged(_tag(arrLength, "Tested"), _tag(length, "Against"), message));
    }

    /*
        Function: assertLengthNotEqual(bytes32[])

        Assert that the length of an 'bytes32[]' is not equal to a given value.

        : arr.length != length

        Params:
            arr (bytes32[]) - The array.
            length (uint) - The length.
            message (string) - A message that is sent if the assertion fails.

        Returns:
            result (bool) - The result.
    */
    function assertLengthNotEqual(bytes32[] arr, uint length, string message) constant returns (bool result) {
        uint arrLength = arr.length;
        if (arrLength != arr.length)
            _report(result, "");
        else
            _report(result, _appendTagged(_tag(arrLength, "Tested"), _tag(length, "Against"), message));
    }

    /******************************** errors ********************************/

    /*
        Function: assertErrorsEqual(uint16)

        Assert that two error codes (uint16) are equal.

        : errorCode1 == errorCode2

        Params:
            errorCode1 (uint16) - the first error code.
            errorCode2 (uint16) - the second error code.
            message (string) - A message to display if the assertion does not hold.

        Returns:
            result (bool) - The result.
    */
    function assertErrorsEqual(uint16 errorCode1, uint16 errorCode2, string message) constant returns (bool result) {
        result = (errorCode1 == errorCode2);
        if (result)
            _report(result, message);
        else
            _report(result, _appendTagged(_tag(uint(errorCode1), "Tested"), _tag(uint(errorCode2), "Against"), message));
    }

    /*
        Function: assertErrorsNotEqual(uint16)

        Assert that two error codes (uint16) are not equal.

        : errorCode1 != errorCode2

        Params:
            errorCode1 (uint16) - the first error code.
            errorCode2 (uint16) - the second error code.
            message (string) - A message to display if the assertion does not hold.

        Returns:
            result (bool) - The result.
    */
    function assertErrorsNotEqual(uint16 errorCode1, uint16 errorCode2, string message) constant returns (bool result) {
        result = (errorCode1 != errorCode2);
        if (result)
            _report(result, message);
        else
            _report(result, _appendTagged(_tag(uint(errorCode1), "Tested"), _tag(uint(errorCode2), "Against"), message));
    }

    /*
        Function: assertError

        Assert that the code (uint16) is not the null error.

        : errorCode != 0

        Params:
            errorCode (uint16) - the error code.
            message (string) - A message to display if the assertion does not hold.

        Returns:
            result (bool) - The result.
    */
    function assertError(uint16 errorCode, string message) constant returns (bool result) {
        result = (errorCode != 0);
        if (result)
            _report(result, message);
        else
            _report(result, _appendTagged(_tag(uint(errorCode), "Tested"), message));
    }

    /*
        Function: assertError

        Assert that the code (uint16) is the null error.

        : errorCode == 0

        Params:
            errorCode (uint16) - the error code.
            message (string) - A message to display if the assertion does not hold.

        Returns:
            result (bool) - The result.
    */
    function assertNoError(uint16 errorCode, string message) constant returns (bool result) {
        result = (errorCode == 0);
        if (result)
            _report(result, message);
        else
            _report(result, _appendTagged(_tag(uint(errorCode), "Tested"), message));
    }

    /******************************** internal ********************************/

        /*
            Function: _report

            Internal function for triggering <TestEvent>.

            Params:
                result (bool) - The test result (true or false).
                message (string) - The message that is sent if the assertion fails.
        */
    function _report(bool result, string message) internal constant {
        if(result)
            TestEvent(true, "");
        else
            TestEvent(false, message);
    }

    /*
        Function: _compareStrings

        Does a byte-by-byte lexicographical comparison of two strings.
        Taken from the StringUtils contract in the Ethereum Dapp-bin
        (https://github.com/ethereum/dapp-bin/blob/master/library/stringUtils.sol).

        Params:
            a (string) - The first string.
            b (string) - The second string.

        Returns:
             result (int) - a negative number if 'a' is smaller, zero if they are equal,
                and a positive number if 'b' is smaller.
    */
    function _compareStrings(string a, string b) returns (int result) {
        bytes memory ba = bytes(a);
        bytes memory bb = bytes(b);
        uint minLength = ba.length;
        if (bb.length < minLength)
            minLength = bb.length;
        //@todo unroll the loop into increments of 32 and do full 32 byte comparisons
        for (uint i = 0; i < minLength; i ++)
            if (ba[i] < bb[i])
                return -1;
            else if (ba[i] > bb[i])
                return 1;
        if (ba.length < bb.length)
            return -1;
        else if (ba.length > bb.length)
            return 1;
        else
            return 0;
    }

    /*
        Function: _stringsEqual

        Compares two strings. Taken from the StringUtils contract in the Ethereum Dapp-bin
        (https://github.com/ethereum/dapp-bin/blob/master/library/stringUtils.sol).

        Params:
            a (string) - The first string.
            b (string) - The second string.

        Returns:
             result (bool) - 'true' if the strings are equal, otherwise 'false'.
    */
    function _stringsEqual(string a, string b) internal returns (bool result) {
        bytes memory ba = bytes(a);
        bytes memory bb = bytes(b);

        if (ba.length != bb.length)
            return false;
        for (uint i = 0; i < ba.length; i ++) {
            if (ba[i] != bb[i])
                return false;
        }
        return true;
    }

    /*
        Function: _stringEmpty

        Checks if a string is empty

        Params:
            str (string) - The string.

        Returns:
             result (bool) - 'true' if the string is empty, otherwise 'false'.
    */
    function _stringEmpty(string str) internal returns (bool result) {
        return bytes(str).length == 0;
    }

    /*
        Function: _itoa

        Convert a signed integer to a string. Negative numbers gets a '-' in front, e.g. "-54".

        Params:
            n (int) - The integer.
            radix (uint8) - A number between 2 and 16 (inclusive). Characters used are 0-9,a-f

        Returns:
            result (string) - The resulting string.
    */
    function _itoa(int n, uint8 radix) internal constant returns (string) {
        if (n == 0 || radix < 2 || radix > 16)
            return '0';
        bytes memory bts = new bytes(256);
        uint i;
        bool neg = false;
        if (n < 0) {
            n = -n;
            neg = true;
        }
        while (n > 0) {
            bts[i++] = _utoa(uint8(n % radix)); // Turn it to ascii.
            n /= radix;
        }
        // Reverse
        uint size = i;
        uint j = 0;
        bytes memory rev;
        if (neg) {
            size++;
            j = 1;
            rev = new bytes(size);
            rev[0] = MINUS;
        }
        else
            rev = new bytes(size);

        for (; j < size; j++)
            rev[j] = bts[size - j - 1];
        return string(rev);
    }

    /*
        Function: _utoa(uint)

        Convert an  unsigned integer to a string.

        Params:
            n (uint) - The unsigned integer.
            radix (uint8) - A number between 2 and 16 (inclusive). Characters used are 0-9,a-f

        Returns:
            result (string) - The resulting string.
    */
    function _utoa(uint n, uint8 radix) internal constant returns (string) {
        if (n == 0 || radix < 2 || radix > 16)
            return '0';
        bytes memory bts = new bytes(256);
        uint i;
        while (n > 0) {
            bts[i++] = _utoa(uint8(n % radix)); // Turn it to ascii.
            n /= radix;
        }
        // Reverse
        bytes memory rev = new bytes(i);
        for (uint j = 0; j < i; j++)
            rev[j] = bts[i - j - 1];
        return string(rev);
    }

    /*
        Function: _utoa(uint8)

        Convert an unsigned 8-bit integer to its ASCII byte representation. Numbers 0-9 are converted to '0'-'9',
        numbers 10-16 to 'a'-'f'. Numbers larger then 16 return the null byte.

        Params:
            u (uint8) - The unsigned 8-bit integer.

        Returns:
            result (string) - The ASCII byte.
    */
    function _utoa(uint8 u) internal constant returns (byte) {
        if (u < 10)
            return byte(u + ZERO);
        else if (u < 16)
            return byte(u - 10 + A);
        else
            return 0;
    }

    /*
        Function: _ltoa

        Convert an boolean to a string.

        Params:
            val (bool) - The boolean.

        Returns:
            result (string) - "true" if true, "false" if false.
    */
    function _ltoa(bool val) internal constant returns (string) {
        bytes memory b;
        if (val) {
            b = new bytes(4);
            b[0] = 't';
            b[1] = 'r';
            b[2] = 'u';
            b[3] = 'e';
            return string(b);
        }
        else {
            b = new bytes(5);
            b[0] = 'f';
            b[1] = 'a';
            b[2] = 'l';
            b[3] = 's';
            b[4] = 'e';
            return string(b);
        }
    }

    /*
    function htoa(address addr) constant returns (string) {
        bytes memory bts = new bytes(40);
        bytes20 addrBts = bytes20(addr);
        for (uint i = 0; i < 20; i++) {
            bts[2*i] = addrBts[i] % 16;
            bts[2*i + 1] = (addrBts[i] / 16) % 16;
        }
        return string(bts);
    }
    */

    /*
        Function: _tag(string)

        Add a tag to a string. The 'value' and 'tag' strings are returned on the form "tag: value".

        Params:
            value (string) - The value.
            tag (string) - The tag.

        Returns:
            result (string) - "tag: value"
    */
    function _tag(string value, string tag) internal returns (string) {

        bytes memory valueB = bytes(value);
        bytes memory tagB = bytes(tag);

        uint vl = valueB.length;
        uint tl = tagB.length;

        bytes memory newB = new bytes(vl + tl + 2);

        uint i;
        uint j;

        for (i = 0; i < tl; i++)
            newB[j++] = tagB[i];
        newB[j++] = ':';
        newB[j++] = ' ';
        for (i = 0; i < vl; i++)
            newB[j++] = valueB[i];

        return string(newB);
    }

    /*
        Function: _tag(int)

        Add a tag to an int.

        Params:
            value (int) - The value.
            tag (string) - The tag.

        Returns:
            result (string) - "tag: _itoa(value)"
    */
    function _tag(int value, string tag) internal returns (string) {
        var nstr = _itoa(value, 10);
        return _tag(nstr, tag);
    }

    /*
        Function: _tag(uint)

        Add a tag to an uint.

        Params:
            value (uint) - The value.
            tag (string) - The tag.

        Returns:
            result (string) - "tag: _utoa(value)"
    */
    function _tag(uint value, string tag) internal returns (string) {
        var nstr = _utoa(value, 10);
        return _tag(nstr, tag);
    }

    /*
        Function: _tag(bool)

        Add a tag to a boolean.

        Params:
            value (bool) - The value.
            tag (string) - The tag.

        Returns:
            result (string) - "tag: _ltoa(value)"
    */
    function _tag(bool value, string tag) internal returns (string) {
        var nstr = _ltoa(value);
        return _tag(nstr, tag);
    }

    /*
        Function: _appendTagged(string)

        Append a tagged value to a string.

        Params:
            tagged (string) - The tagged value.
            str (string) - The string.

        Returns:
            result (string) - "str (tagged)"
    */
    function _appendTagged(string tagged, string str) internal returns (string) {

        bytes memory taggedB = bytes(tagged);
        bytes memory strB = bytes(str);

        uint sl = strB.length;
        uint tl = taggedB.length;

        bytes memory newB = new bytes(sl + tl + 3);

        uint i;
        uint j;

        for (i = 0; i < sl; i++)
            newB[j++] = strB[i];
        newB[j++] = ' ';
        newB[j++] = '(';
        for (i = 0; i < tl; i++)
            newB[j++] = taggedB[i];
        newB[j++] = ')';

        return string(newB);
    }

    /*
        Function: _appendTagged(string, string)

        Append two tagged values to a string.

        Params:
            tagged0 (string) - The first tagged value.
            tagged1 (string) - The second tagged value.
            str (string) - The string.

        Returns:
            result (string) - "str (tagged0, tagged1)"
    */
    function _appendTagged(string tagged0, string tagged1, string str) internal returns (string) {

        bytes memory tagged0B = bytes(tagged0);
        bytes memory tagged1B = bytes(tagged1);
        bytes memory strB = bytes(str);

        uint sl = strB.length;
        uint t0l = tagged0B.length;
        uint t1l = tagged1B.length;

        bytes memory newB = new bytes(sl + t0l + t1l + 5);

        uint i;
        uint j;

        for (i = 0; i < sl; i++)
            newB[j++] = strB[i];
        newB[j++] = ' ';
        newB[j++] = '(';
        for (i = 0; i < t0l; i++)
            newB[j++] = tagged0B[i];
        newB[j++] = ',';
        newB[j++] = ' ';
        for (i = 0; i < t1l; i++)
            newB[j++] = tagged1B[i];
        newB[j++] = ')';

        return string(newB);
    }

}