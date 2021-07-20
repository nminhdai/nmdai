#include <iostream>
#include <vector>
using namespace std;

class Solution {
public:
    vector<int> grayCode(int n) {
        vector <int> ans;
        for(int i = 0; i < 1<<n; i++){
            ans.push_back(i^(i>>1));
        }
        return ans;
    }

    void print_vector(vector<int> v){
        cout << "[";
        int i;
        for(i = 0; i < v.size() - 1; i++) {
            cout << v[i] << ",";
        }
        cout << v[i] << "]" << endl;
    }
};

int main() {
    Solution a;
    a.print_vector(a.grayCode(2));
}