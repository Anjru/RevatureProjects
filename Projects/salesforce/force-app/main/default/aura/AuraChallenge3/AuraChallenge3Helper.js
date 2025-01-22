({
    helperMethod: function (component, event) {
        // Fetch input values
        const name = component.find("inputName").get("v.value");
        const rating = component.find("inputRating").get("v.value");
        const employees = component.find("inputEmployees").get("v.value");
        const annualRevenue = component.find("inputAnnualRevenue").get("v.value");

        // Call Apex method
        const action = component.get("c.createAccount");
        action.setParams({ name, rating, Employees: employees, annualRevenue });

        action.setCallback(this, function (response) {
            const state = response.getState();
            if (state === "SUCCESS") {
                console.log("Account created successfully");
            } else if (state === "ERROR") {
                const errors = response.getError();
                console.error(errors[0].message);
            }

            const toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: "Success",
                message: "This is a toast message!",
                type: "success"
            });
            toastEvent.fire();
        });

        $A.enqueueAction(action);
    }

});


