#include <iostream>
#include <vector>
using namespace std;

class Solution {
public:
    int findPeakElement(vector<int>& nums) {
        for (int i = 0; i < nums.size() - 1; i++){
            if (nums[i] > nums[i + 1])
                return i;
        }
        return nums.size() - 1;
    }
};

int main(){
    Solution b;
    vector<int> nums = {1,2,3,1};
    cout << b.findPeakElement(nums);
}